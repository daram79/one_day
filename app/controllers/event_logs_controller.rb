class EventLogsController < ApplicationController
  before_action :set_event_log, only: [:show, :edit, :update, :destroy]

  # GET /event_logs
  # GET /event_logs.json
  def index
    # @event_logs = EventLog.all
    start_date = Time.now.beginning_of_day
    end_date = Time.now.end_of_day
    
    #today
    #dau
    dau = EventLog.where("created_at between  ? and ?", start_date, end_date).pluck("event_user_id")
    if dau.blank?
      @dau_size = 0
    else
      @dau_size = dau.uniq!.size
    end
    
    
    @connect_user_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "connect_user").count
    
    
    
    #push 방문 접속자
    @push_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_push").count
    
    #push 편의점 방문 접속자
    @conveni_gs25_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_gs25").count
    
    
    @conveni_seven_eleven_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_seven_eleven").count
    
    
    @conveni_mini_stop_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_mini_stop").count
    
    
    @conveni_cu_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_cu").count
    
    @conveni_search_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_search1+1").count
    
    @conveni_search_words = EventLog.where("created_at between  ? and ? and log_type = ?", start_date, end_date, "search_1+1").pluck(:action_type)
    
    @click_content_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_hotdeal_content").count
    
    
    #yesterday
    #dau
    start_date = start_date.yesterday
    end_date = start_date.yesterday
    
    
    dau = EventLog.where("created_at between  ? and ?", start_date, end_date).pluck("event_user_id")
    if dau.blank?
      @yesterday_dau_size = 0
    else
      @yesterday_dau_size = dau.uniq!.size
    end
    
    
    @yesterday_connect_user_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "connect_user").count
    
    
    
    #push 방문 접속자
    @yesterday_push_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_push").count
    
    #push 편의점 방문 접속자
    @yesterday_conveni_gs25_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_gs25").count
    
    
    @yesterday_conveni_seven_eleven_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_seven_eleven").count
    
    
    @yesterday_conveni_mini_stop_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_mini_stop").count
    
    
    @yesterday_conveni_cu_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_cu").count
    
    @yesterday_conveni_search_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_search1+1").count
    
    @yesterday_conveni_search_words = EventLog.where("created_at between  ? and ? and log_type = ?", start_date, end_date, "search_1+1").pluck(:action_type)
    
    @yesterday_click_content_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_hotdeal_content").count
    
  end

  # GET /event_logs/1
  # GET /event_logs/1.json
  def show
  end

  # GET /event_logs/new
  def new
    @event_log = EventLog.new
  end

  # GET /event_logs/1/edit
  def edit
  end
  
  def insert_log
    event_log = EventLog.new(event_log_params)
    event_log.save
    
    render json: {status: :ok}
  end

  # POST /event_logs
  # POST /event_logs.json
  def create
    @event_log = EventLog.new(event_log_params)

    respond_to do |format|
      if @event_log.save
        format.html { redirect_to @event_log, notice: 'Event log was successfully created.' }
        format.json { render :show, status: :created, location: @event_log }
      else
        format.html { render :new }
        format.json { render json: @event_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_logs/1
  # PATCH/PUT /event_logs/1.json
  def update
    respond_to do |format|
      if @event_log.update(event_log_params)
        format.html { redirect_to @event_log, notice: 'Event log was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_log }
      else
        format.html { render :edit }
        format.json { render json: @event_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_logs/1
  # DELETE /event_logs/1.json
  def destroy
    @event_log.destroy
    respond_to do |format|
      format.html { redirect_to event_logs_url, notice: 'Event log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_log
      @event_log = EventLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_log_params
      # params.fetch(:event_log, {})
      params[:event_log].permit(:event_user_id, :screen_type, :action_type, :log_type)
    end
end
