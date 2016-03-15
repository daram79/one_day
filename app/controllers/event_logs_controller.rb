class EventLogsController < ApplicationController
  before_action :set_event_log, only: [:show, :edit, :update, :destroy]

  # GET /event_logs
  # GET /event_logs.json
  def index
    # @event_logs = EventLog.all
    @log_type_ary = ["new_user_count", "dau_count", "connect_count", "push_connect_count", "gs25_connect_count", "seven_eleven_connect_count", "mini_stop_connect_count",
                    "cu_connect_count", "search_connect_count", "gguldeal_content_click_count"]
    
    start_date = Time.now.beginning_of_day
    end_date = Time.now.end_of_day
    
    #today
    #dau
    
    @today_logs = Hash.new
    
    @today_logs[:"#{@log_type_ary[0]}"] = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "create_user").count
    
    dau = EventLog.where("created_at between  ? and ?", start_date, end_date).pluck("event_user_id")
    if dau.blank?
      @today_logs[:"#{@log_type_ary[1]}"] = 0
    else
      @today_logs[:"#{@log_type_ary[1]}"] = dau.uniq!.size
    end
        
    @today_logs[:"#{@log_type_ary[2]}"] = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "connect_user").count
    
    
    
    #push 방문 접속자
    @today_logs[:"#{@log_type_ary[3]}"] = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_push").count
    
    #push 편의점 방문 접속자
    @today_logs[:"#{@log_type_ary[4]}"] = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_gs25").count
    
    
    @today_logs[:"#{@log_type_ary[5]}"] = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_seven_eleven").count
    
    
    @today_logs[:"#{@log_type_ary[6]}"] = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_mini_stop").count
    
    
    @today_logs[:"#{@log_type_ary[7]}"] = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_cu").count
    
    @today_logs[:"#{@log_type_ary[8]}"] = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_search1+1").count
    
    @today_logs[:"#{@log_type_ary[9]}"] = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_hotdeal_content").count
    
    tmp_datas = EventLog.where("created_at between  ? and ? and log_type = ?", start_date, end_date, "search_1+1").pluck(:action_type)
    @today_search_words = []
    tmp_datas.each do |word|
      @today_search_words.push word.split("_")[-1]
    end
    
    
    #yesterday
    #dau
    
    
    @log_histories = Hash.new
    @log_type_ary.each do |log_type|
      @log_histories[:"#{log_type}"] = EventLogHistory.where(log_type: log_type).order(:id)
    end
    
    @search_words = Hash.new
    
    search_word_datas = EventLogHistory.where(log_type: "search_word").order("id desc")
    search_word_datas.each do |data|
      @search_words["#{data.created_at.in_time_zone("Asia/Seoul").strftime("%Y-%m-%d")}"] = "" unless @search_words["#{data.created_at.in_time_zone("Asia/Seoul").strftime("%Y-%m-%d")}"]
      @search_words["#{data.created_at.in_time_zone("Asia/Seoul").strftime("%Y-%m-%d")}"] += "#{data.value}/"
    end
    
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
