# coding : utf-8

class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :edit_data]
  
  @@super_deal_ids = [9001, 9002]

  # GET /events
  # GET /events.json
  def index
    @events = Event.where("event_site_id > 1000").where(show_flg: false, update_flg: false, super_flg: true).order("id desc")
    # @events = Event.where(show_flg: false, update_flg: false).order("id desc")
  end
  
  def event_true
    event_site_ids = [4001, 4002, 4003, 4004, 9001, 9002, 9900, 9901, 9902, 9903, 9904, 9905, 9906, 9907, 9999, 10001, 10002, 9992, 9993]
    @events = Event.where(event_site_id: event_site_ids, show_flg: true, super_flg: true).order("id desc")
    # @events = Event.where(show_flg: true).order("id desc")
    render "index"
  end
  
  def event_false
    event_site_ids = [4001, 4002, 4003, 4004, 9001, 9002, 9900, 9901, 9902, 9903, 9904, 9905, 9906, 9907, 9999, 10001, 10002, 9992, 9993]
    @events = Event.where(event_site_id: event_site_ids, show_flg: false, super_flg: true).order("id desc")
    # @events = Event.where(show_flg: false).order("id desc")
    render "index"
  end
  
  def add_item
    @event = Event.new
    @event.event_images.build
  end
  
  def new2
    
  end
  
  def edit_data
    if @event.original_price
      @event.original_price.delete!("원")
      @event.original_price.delete!(",")
    end
  end
  
  def create_event
    data = Event.get_datas(params[:event][:url])
    Event.create(event_id: data[:event_id], event_name: data[:event_name], event_url: data[:event_url], event_site_id: data[:event_site_id],
                  image_url: data[:image_url], discount: data[:discount], price: data[:price], original_price: data[:original_price] ) if data
    flash[:notice] = "데이터 작성 완료"
    if Rails.env == 'development'
      redirect_to :action => "new2"
    else
      redirect_to :action => "new2", :port => 81
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    @event.event_images.build
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    ret = true
    if params[:event][:event_name] == ""
      flash[:notice] = "타이틀을 입력해 주세요."
      ret = false
    elsif params[:event][:event_url] == ""
      flash[:notice] = "사이트 url을 입력해 주세요."
      ret = false
    elsif params[:event][:image_url] == "" && params[:event][:event_images_attributes] == nil
      flash[:notice] = "이미지 URL을 입력해 주세요."
      ret = false      
    end
    unless ret
      redirect_to :action => "add_item"
      return
    end
    @event = Event.new(event_params)
    respond_to do |format|
      if @event.save
        # format.html { redirect_to @event, notice: 'Event was successfully created.' }
        # format.html { redirect_to '/add_item', notice: '데이터 작성 완료' }
        if params[:event][:event_site_id] == "10001" || params[:event][:event_site_id] == "10002"
          #이미지 링크 처리
          flash[:notice] = "데이터 작성 완료"
          event_url = URI.extract(params[:event][:event_name])[0]
          unless event_url.blank?
            i = @event.event_name.index("http") - 1
            @event.update(event_name: @event.event_name[0..i].rstrip, event_url: event_url)  
          end
          if Rails.env == 'development'
            @event.update(image_url: "http://192.168.0.4:3000#{@event.event_images[0].image_url.to_s}", event_url: event_url) unless @event.event_images.blank?
            format.html { redirect_to :action => "new" }
          else
            @event.update(image_url: "http://happyhouse.me:81#{@event.event_images[0].image_url.to_s}", event_url: event_url) unless @event.event_images.blank?
            format.html { redirect_to :action => "new", :port => 81 }
          end
          format.json { render :add_item, status: :created, location: @event }
        else
          flash[:notice] = "데이터 작성 완료"
          
          if params[:event][:event_images_attributes]
            if Rails.env == 'development'
              @event.update(image_url: "http://192.168.0.4:3000#{@event.event_images[0].image_url.to_s}") unless @event.event_images.blank?
            else
              @event.update(image_url: "http://happyhouse.me:81#{@event.event_images[0].image_url.to_s}") unless @event.event_images.blank?
            end
          end
          if Rails.env == 'development'
            format.html { redirect_to :action => "add_item" }
          else
            format.html { redirect_to :action => "add_item", :port => 81 }
          end
          
          format.json { render :add_item, status: :created, location: @event }
        end
      else
        format.html { render :add_item }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        # format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        # format.json { render :show, status: :ok, location: @event }
        if Rails.env == 'development'
            format.html { redirect_to :action => "event_true" }
          else
            format.html { redirect_to :action => "event_true", :port => 81 }
          end
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def get_event
    event_site_ids = EventSite.where("id > 6").ids
    # @event = Event.where(event_site_id: event_site_ids).order("id desc")
    @event = Event.where(show_flg: true, super_flg: true).where("event_site_id > 1000").order("id desc")
    # @event = Event.where(show_flg: true).order("id desc")
    respond_to do |format|
      format.html { @event }
      format.json { render json: @event }
    end
    # render json: @event
  end
  
  def get_event_all
    @event = Event.where(show_flg: true).where("event_site_id > 1000").where('event_site_id NOT IN (?)', @@super_deal_ids).order("id desc")
    respond_to do |format|
      format.html { render "get_event" }
      format.json { render json: @event }
    end
  end
  
  def get_event_cafe
    @event = Event.where(show_flg: true, deal_search_word_id: 10002, item_type_code: params[:tabIndex], super_flg: true).order("price asc")
    respond_to do |format|
      format.html { render "get_event" }
      format.json { render json: @event }
    end
  end
  
  def get_event_eat
    case params[:typeIndex]
    when "0"
      @event = Event.where(show_flg: true, item_type_code: 0, super_flg: true).where("event_site_id > 1000").order("id desc")  
    else
      @event = Event.where(show_flg: true, item_type_code: 0, deal_search_word_id: params[:typeIndex].to_i, super_flg: true).where("event_site_id > 1000").order("id desc")
    end
    
    respond_to do |format|
      format.html { render "get_event" }
      format.json { render json: @event }
    end
  end
  
  def get_event_play
    case params[:typeIndex]
    when "0"
      @event = Event.where(show_flg: true, item_type_code: 1, super_flg: true).where("event_site_id > 1000").order("id desc")
    else
      @event = Event.where(show_flg: true, item_type_code: 1, deal_search_word_id: params[:typeIndex].to_i, super_flg: true).where("event_site_id > 1000").order("id desc")
    end
    
    # @event = Event.where(show_flg: true).order("id desc")
    respond_to do |format|
      format.html { render "get_event" }
      format.json { render json: @event }
    end
  end
  
  def get_event_movie
    @event = Event.where(show_flg: true, deal_search_word_id: 10001, super_flg: true).order("id desc")
    
    # @event = Event.where(show_flg: true).order("id desc")
    respond_to do |format|
      format.html { render "get_event" }
      format.json { render json: @event }
    end
  end
  
  def get_hot_all
    # event_site_ids = [4001, 4002, 4003, 9001, 9002, 9900]
    event_site_ids = [4001, 4002, 4003, 4004, 9001, 9002, 9900, 9901, 9902, 9903, 9904, 9905, 9906, 9907, 9999, 9992, 9993]
    # @event = Event.where(event_site_id: event_site_ids).order("id desc")
    @event = Event.where(event_site_id: event_site_ids, super_flg: true).order("show_flg desc").order("id desc")
       
    # @event = Event.where(show_flg: true).order("id desc")
    respond_to do |format|
      format.html { render "get_event" }
      format.json { render json: @event }
    end
  end
  
  def get_advance_registration
    event_site_ids = [9992]
    @event = Event.where(event_site_id: event_site_ids, super_flg: true).order("show_flg desc").order("id desc")
       
    # @event = Event.where(show_flg: true).order("id desc")
    respond_to do |format|
      format.html { render "get_event" }
      format.json { render json: @event }
    end
  end
  
  def get_lottery_event
    event_site_ids = [9993] #추첨 이벤트
    @event = Event.where(event_site_id: event_site_ids, super_flg: true).order("show_flg desc").order("id desc")
       
    # @event = Event.where(show_flg: true).order("id desc")
    respond_to do |format|
      format.html { render "get_event" }
      format.json { render json: @event }
    end
  end
  
  def get_hot_offline
    # event_site_ids = [4001, 4002, 4003, 9001, 9002, 9900]
    event_site_ids = [10001]
    # @event = Event.where(event_site_id: event_site_ids).order("id desc")
    @event = Event.where(event_site_id: event_site_ids, super_flg: true).order("show_flg desc").order("id desc")
       
    # @event = Event.where(show_flg: true).order("id desc")
    respond_to do |format|
      format.html { render "get_event" }
      format.json { render json: @event }
    end
  end
  
  def get_hot_online
    # event_site_ids = [4001, 4002, 4003, 9001, 9002, 9900]
    event_site_ids = [10002]
    # @event = Event.where(event_site_id: event_site_ids).order("id desc")
    @event = Event.where(event_site_id: event_site_ids, super_flg: true).order("show_flg desc").order("id desc")
       
    # @event = Event.where(show_flg: true).order("id desc")
    respond_to do |format|
      format.html { render "get_event" }
      format.json { render json: @event }
    end
  end
  
  def get_hot_deal
    event_site_ids = [9001, 9002, 9900, 9900, 9901, 9902, 9903, 9904, 9905, 9906, 9907, 9999]
    @event = Event.where(event_site_id: event_site_ids, super_flg: true).order("show_flg desc").order("id desc")
    
    # @event = Event.where(show_flg: true).order("id desc")
    respond_to do |format|
      format.html { render "get_event" }
      format.json { render json: @event }
    end
  end
  
  def get_hot_movie
    event_site_ids = [4001, 4002, 4003, 4004]
    @event = Event.where(event_site_id: event_site_ids, super_flg: true).order("show_flg desc").order("id desc")
    
    # @event = Event.where(show_flg: true).order("id desc")
    respond_to do |format|
      format.html { render "get_event" }
      format.json { render json: @event }
    end
  end
  
  def show_data
    event = Event.find(params[:id])
    if event.update_flg && !event.show_flg
      render json: {flg: false}
    elsif event.update_flg && event.show_flg
      render json: {flg: true}
    else
      event.update(show_flg: true, update_flg: true)
      render json: {flg: true}
    end
  end
  
  def hide_data
    event = Event.find(params[:id])
    if event.update_flg && event.show_flg
      render json: {flg: false}
    elsif event.update_flg && !event.show_flg
      render json: {flg: true}
    else
      event.update(show_flg: false, update_flg: true)
      render json: {flg: true}
    end
  end
  
  def add_push
    event = Event.find(params[:id])
    Event.send_push_button(event)
    # if event.push_flg
      # render json: {flg: true}
    # else
      # users = EventMailingList.all
      # EventUserPush
      # ActiveRecord::Base.transaction do
        # users.each do|user|
          # EventUserPush.create(event_id: event.id, event_user_id: user.id)
        # end
      # end
      # event.update(show_flg: true, push_flg: true, update_flg: true)
      render json: {flg: true}
    # end
  end
  
  def force_data
    event = Event.find(params[:id])
    if params[:flg] == "show"
      event.update(show_flg: true)
    else
      event.update(show_flg: false)
    end
    render json: {flg: true}
  end
  
  def get_new_flg
    # data = EventUserAlram.where(event_mailing_list_id: params[:user_id]).pluck(:menu_id)
    render json: {flg: true}
  end
  
  def del_new_flg
    data = EventUserAlram.where(event_mailing_list_id: params[:user_id], menu_id: params[:menu_id]).pluck(:menu_id)
    
    del_data = EventUserAlram.where(event_mailing_list_id: params[:user_id], menu_id: params[:menu_id])
    del_data.destroy_all
    render json: data
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params[:event].permit(:event_site_id, :event_name, :event_url, :image_url, :discount, :price, :original_price, :show_flg, :push_flg, :update_flg, event_images_attributes: [:image])
    end
end
