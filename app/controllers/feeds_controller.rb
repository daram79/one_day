# coding : utf-8

class FeedsController < ApplicationController
  include ActionView::Helpers::DateHelper
  
  before_action :set_feed, only: [:edit, :update, :destroy, :comment]

  # GET /feeds
  # GET /feeds.json
  def index
    @current_user = User.find(params[:user_id])
    
    # search_start_time = Time.now.utc - 1
    search_start_time = (DateTime.now - 1).utc
    @feeds = Feed.where("created_at > ?", search_start_time).order('updated_at desc').limit(100)
    @time_word = Hash.new
    @feeds.each do |feed|
      @time_word[feed.id] = time_ago_in_words(feed.created_at)
    end
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    @current_user = User.find(params[:user_id])
    # @item_photo = @feed.feed_photos[0]
    search_start_time = (DateTime.now - 1).utc
    @feed = Feed.where("id = ? and created_at > ?", params[:id], search_start_time).first
    @item_photo = @feed.feed_photos[0] if @feed
    @time_word = time_ago_in_words(@feed.created_at)
  end

  # GET /feeds/new
  def new
    @feed = Feed.new
  end

  # GET /feeds/1/edit
  def edit
  end

  # POST /feeds
  # POST /feeds.json
  def create
    content_type = params[:feed][:feed_photos_attributes]["0"][:image].content_type
    unless "image".eql?(content_type.split('/')[0])
      flash[:notice] = "지원하지 않는 형식의 사진입니다."
      redirect_to action: "new"
    else
      content = params[:feed][:content]
      tags = Feed.get_tag(content) #태그 작성후 DB에 넣고 태그값 리턴해줌
      html_content = Feed.make_html(content, tags)
      #@feed = Feed.new(feed_params)
      nick = User.get_nick
      @feed = Feed.new(feed_params.merge(html_content: html_content, nick: nick))
      respond_to do |format|
        if @feed.save
          #format.html { redirect_to @feed, notice: 'Feed was successfully created.' }
          Feed.create_tag(@feed.id, tags)
          format.html { redirect_to feeds_url, notice: 'Feed was successfully created.' }
          format.json { render :show, status: :created, location: @feed }
        else
          format.html { render :new }
          format.json { render json: @feed.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /feeds/1
  # PATCH/PUT /feeds/1.json
  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
        format.json { render :show, status: :ok, location: @feed }
      else
        format.html { render :edit }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed.destroy
    respond_to do |format|
      format.html { redirect_to feeds_url, notice: 'Feed was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def add_like
    current_user = User.find(params[:user_id])
    like = Like.where(feed_id: params[:id], user_id: current_user.id).first
    unless like
      like_flg = true
      like = Like.create(feed_id:params[:id] , user_id: current_user.id, like_type: "feed")
    else
      like.destroy
      like_flg = false
    end
    like_count = Like.where(feed_id:params[:id]).count
    like.feed.update(like_count: like_count)
    render json: {like_flg: like_flg}
  end
  
  def search_tag
    tag = params[:tag]
    search_start_time = (DateTime.now - 1).utc
    feed_ids = FeedTag.where("tag_name = ? and created_at > ?",tag, search_start_time).pluck(:feed_id)
    @feeds = Feed.where(id: feed_ids)
  end
  
  def comment
    @comments = @feed.comments
    @time_word = Hash.new
    @comments.each do |comment|
      @time_word[comment.id] = time_ago_in_words(comment.created_at)
    end
  end
  
  def add_comment
    current_user = User.find(params[:user_id])
    
    feed = Feed.find(params[:id])
    nick = feed.nick
    if feed.user_id != current_user.id
      while nick.eql?(feed.nick)
        nick = User.get_nick
      end
    end
    comment = Comment.create(feed_id:params[:id] , user_id: current_user.id, content: params[:comment_content], ip: params[:ip], nick: nick)
    comment_count = Comment.where(feed_id:params[:id]).count
    comment.feed.update(comment_count: comment_count)
    
    render json: {comment_content: comment.content, nick: comment.nick}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_params
      params[:feed].permit(:user_id, :content, :html_content, :nick, :ip, feed_photos_attributes: [:image])
    end
end
