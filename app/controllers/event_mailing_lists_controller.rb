class EventMailingListsController < ApplicationController
  before_action :set_event_mailing_list, only: [:show, :edit, :update, :destroy]

  # GET /event_mailing_lists
  # GET /event_mailing_lists.json
  def index
    @event_mailing_list = EventMailingList.new
    @event_sites = EventSite.all
    # if params[:id]
      # @mail = EventMailingList.find(params[:id])
    # end
  end

  # GET /event_mailing_lists/1
  # GET /event_mailing_lists/1.json
  def show
  end

  # GET /event_mailing_lists/new
  def new
    @event_mailing_list = EventMailingList.new
  end

  # GET /event_mailing_lists/1/edit
  def edit
  end

  # POST /event_mailing_lists
  # POST /event_mailing_lists.json
  def create
    @event_mailing_list = EventMailingList.find_by_email(params[:event_mailing_list][:email])
    unless @event_mailing_list
      @event_mailing_list = EventMailingList.new(event_mailing_list_params)
      @event_mailing_list.save
    end
    # redirect_to controller: 'event_mailing_lists', action: 'index', id: @event_mailing_list.id

    # respond_to do |format|
      # if @event_mailing_list.save
        # # format.html { redirect_to @event_mailing_list, notice: 'Event mailing list was successfully created.' }
        # format.html { redirect_to controller: 'event_mailing_lists', action: 'index', id: @event_mailing_list.id }
        # format.json { render :show, status: :created, location: @event_mailing_list }
      # else
        # format.html { render :new }
        # format.json { render json: @event_mailing_list.errors, status: :unprocessable_entity }
      # end
    # end
  end

  # PATCH/PUT /event_mailing_lists/1
  # PATCH/PUT /event_mailing_lists/1.json
  def update
    respond_to do |format|
      if @event_mailing_list.update(event_mailing_list_params)
        format.html { redirect_to @event_mailing_list, notice: 'Event mailing list was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_mailing_list }
      else
        format.html { render :edit }
        format.json { render json: @event_mailing_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_mailing_lists/1
  # DELETE /event_mailing_lists/1.json
  def destroy
    @event_mailing_list.destroy
    respond_to do |format|
      format.html { redirect_to event_mailing_lists_url, notice: 'Event mailing list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def create_ajax
    event_mailing_list = EventMailingList.find_by_email(params[:mail])
    unless event_mailing_list
      event_mailing_list = EventMailingList.create(email: params[:mail])
    end
    site_names = EventSite.all.pluck(:site_name)
    event_receive_users = event_mailing_list.event_receive_users
    render :json => {status: :ok, data: event_mailing_list, event_receive_users: event_receive_users, site_names: site_names}
  end
  
  def del_mail
    @email = EventMailingList.find(params[:mail_id])
    @email.destroy
    render :json => {status: :ok}
  end
  
  def receive_true
    event_receive_user = EventReceiveUser.find(params[:event_receive_user_id])
    event_receive_user.update(is_receive: true)
    render :json => {status: :ok, event_receive_user_id: event_receive_user.id}
  end
  
  def receive_false
    event_receive_user = EventReceiveUser.find(params[:event_receive_user_id])
    event_receive_user.update(is_receive: false)
    render :json => {status: :ok, event_receive_user_id: event_receive_user.id}
  end
  
  def all
    @mails = EventMailingList.all
  end
  
  def add_event_site
    event_site_name = params[:event_site_name]
    EventSite.create(site_name: event_site_name)
    render json: {status: :ok}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_mailing_list
      @event_mailing_list = EventMailingList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_mailing_list_params
      params[:event_mailing_list].permit(:email)
    end
end
