require 'google/apis/oauth2_v2'
require 'google/api_client/client_secrets'
require "google/apis/blogger_v3"

class EventDetailsController < ApplicationController
  before_action :set_event_detail, only: [:show, :edit, :update, :destroy]
  
  Blogger = Google::Apis::BloggerV3
  @@blog_id = "7518029362139104243"
  @@google_code = nil

  # GET /event_details
  # GET /event_details.json
  def index
    @event_details = EventDetail.all
  end

  # GET /event_details/1
  # GET /event_details/1.json
  def show
    @ary_content = [@event_detail.content_1, @event_detail.content_2, @event_detail.content_3, @event_detail.content_4, 
                    @event_detail.content_5, @event_detail.content_6, @event_detail.content_7, @event_detail.content_8,
                    @event_detail.content_9, @event_detail.content_10] 
  end

  # GET /event_details/new
  def blog
    client_secrets = Google::APIClient::ClientSecrets.load("config/client_secret.json")
    auth_client = client_secrets.to_authorization
    auth_client.update!( :scope => 'https://www.googleapis.com/auth/blogger', :redirect_uri => 'http://happyhouse.me:81/event_details/new/' )
    auth_uri = auth_client.authorization_uri.to_s
    redirect_to auth_uri
  end
  
  def new
    @@google_code = params["code"]
    @event_detail = EventDetail.new
    # @event_detail.event_detail_images.build
    10.times { @event_detail.event_detail_images.build }
  end

  # GET /event_details/1/edit
  def edit
  end

  # POST /event_details
  # POST /event_details.json
  def create
    unless @@google_code
      redirect_to :action => "blog"
      return
    end
    
    tmp_content = []
    tmp_content[0] = params[:event_detail][:content_1]
    tmp_content[1] = params[:event_detail][:content_2]
    tmp_content[2] = params[:event_detail][:content_3]
    tmp_content[3] = params[:event_detail][:content_4]
    tmp_content[4] = params[:event_detail][:content_5]
    tmp_content[5] = params[:event_detail][:content_6]
    tmp_content[6] = params[:event_detail][:content_7]
    tmp_content[7] = params[:event_detail][:content_8]
    tmp_content[8] = params[:event_detail][:content_9]
    tmp_content[9] = params[:event_detail][:content_10]
    
    @event_detail = EventDetail.new(event_detail_params)

    respond_to do |format|
      if @event_detail.save
        
        client_secrets = Google::APIClient::ClientSecrets.load("config/client_secret.json")
        auth_client = client_secrets.to_authorization
        auth_client.update!( :scope => 'https://www.googleapis.com/auth/blogger', :redirect_uri => 'http://localhost:3000/event_details/new/' )
        
        auth_client.code = @@google_code
        auth_client.fetch_access_token!
        
        images = []
        
        post = Google::Apis::BloggerV3::Post.new
        post.title = params[:event_detail][:title]        
        
        content = ""
        @event_detail.event_detail_images.each_with_index do |event_detail_image, i|
          image = Google::Apis::BloggerV3::Post::Image.new
          image.url = event_detail_image.image.url
          images.push image.url
          content += "<img src='http://localhost:3000#{event_detail_image.image.url}'/> #{tmp_content[i]}</br></br>"
        end
        post.content = content
        
          
        service = Blogger::BloggerService.new
        service.authorization = auth_client
        ret = service.insert_post(@@blog_id, post)
        ret.url
        
        
        if Rails.env == 'development'
          format.html { redirect_to @event_detail, notice: 'Event detail was successfully created.' }
        else
          format.html { redirect_to :action => "show", :port => 81, id: @event_detail.id }
        end
        # format.html { redirect_to @event_detail, notice: 'Event detail was successfully created.' }
        # format.json { render :show, status: :created, location: @event_detail }
      else
        format.html { render :new }
        format.json { render json: @event_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_details/1
  # PATCH/PUT /event_details/1.json
  def update
    respond_to do |format|
      if @event_detail.update(event_detail_params)
        format.html { redirect_to @event_detail, notice: 'Event detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_detail }
      else
        format.html { render :edit }
        format.json { render json: @event_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_details/1
  # DELETE /event_details/1.json
  def destroy
    @event_detail.destroy
    respond_to do |format|
      format.html { redirect_to event_details_url, notice: 'Event detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_detail
      @event_detail = EventDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_detail_params
      params[:event_detail].permit(:event_id, :title, :content_1, :content_2, :content_3, :content_4, :content_5, :content_6, :content_7, :content_8, :content_9, :content_10, 
                                    :next_url, event_detail_images_attributes: [:image])
    end
end
