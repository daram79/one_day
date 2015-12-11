class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.where("event_site_id > 1000").where(show_flg: false, update_flg: false).order("id desc")
    # @events = Event.where(show_flg: false, update_flg: false).order("id desc")
  end
  
  def event_true
    @events = Event.where("event_site_id > 1000").where(show_flg: true).order("id desc")
    # @events = Event.where(show_flg: true).order("id desc")
    render "index"
  end
  
  def event_false
    @events = Event.where("event_site_id > 1000").where(show_flg: false).order("id desc")
    # @events = Event.where(show_flg: false).order("id desc")
    render "index"
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
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
    @event = Event.where(show_flg: true).where("event_site_id > 1000").order("id desc")
    # @event = Event.where(show_flg: true).order("id desc")
    respond_to do |format|
      format.html { @event }
      format.json { render @event }
    end
    # render json: @event
  end
  
  def get_event_eat
    @event = Event.where(show_flg: true, item_type_code: 0).where("event_site_id > 1000").order("id desc")
    respond_to do |format|
      format.html { render "get_event" }
      format.json { render @event }
    end
  end
  
  def get_event_play
    event_site_ids = EventSite.where("id > 6").ids
    # @event = Event.where(event_site_id: event_site_ids).order("id desc")
    @event = Event.where(show_flg: true, item_type_code: 1).where("event_site_id > 1000").order("id desc")
    # @event = Event.where(show_flg: true).order("id desc")
    respond_to do |format|
      format.html { render "get_event" }
      format.json { render @event }
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
    if event.push_flg
      render json: {flg: true}
    else
      users = EventMailingList.all
      EventUserPush
      ActiveRecord::Base.transaction do
        users.each do|user|
          EventUserPush.create(event_id: event.id, event_user_id: user.id)
        end
      end
      event.update(show_flg: true, push_flg: true, update_flg: true)
      render json: {flg: true}
    end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params[:event]
    end
end
