# coding : utf-8
class EventReservesController < ApplicationController
  before_action :set_event_reserve, only: [:show, :edit, :update, :destroy]

  # GET /event_reserves
  # GET /event_reserves.json
  def index
    @event_reserves = EventReserve.all
  end

  # GET /event_reserves/1
  # GET /event_reserves/1.json
  def show
  end

  # GET /event_reserves/new
  def new
    @event_reserve = EventReserve.new
    @event_reserve.event_images.build
  end

  # GET /event_reserves/1/edit
  def edit
  end

  # POST /event_reserves
  # POST /event_reserves.json
  def create
    # params[:event_reserve][:add_time][1i] = params[:event_reserve][:add_time][1i] - 9
    yy = params[:tmp]["add_time(1i)"]
    mm = params[:tmp]["add_time(2i)"]
    dd = params[:tmp]["add_time(3i)"]
    hour = params[:tmp]["add_time(4i)"]
    min = params[:tmp]["add_time(5i)"]
    add_time = Time.new(yy, mm, dd, hour, min)
    
    yy = params[:tmp]["close_time(1i)"]
    mm = params[:tmp]["close_time(2i)"]
    dd = params[:tmp]["close_time(3i)"]
    hour = params[:tmp]["close_time(4i)"]
    min = params[:tmp]["close_time(5i)"]
    close_time = Time.new(yy, mm, dd, hour, min)
     
    # @event_reserve = EventReserve.new(event_reserve_params)
    @event_reserve = EventReserve.new(event_reserve_params.merge(add_time: add_time, close_time: close_time))
    

    respond_to do |format|
      if @event_reserve.save
        # format.html { redirect_to @event_reserve, notice: 'Event reserve was successfully created.' }
        # format.json { render :show, status: :created, location: @event_reserve }
        flash[:notice] = "데이터 작성 완료"
        
        if Rails.env == 'development'
          @event_reserve.update(image_url: "http://192.168.0.4:3000#{@event_reserve.event_images[0].image_url.to_s}") unless @event_reserve.event_images.blank?
        else
          @event_reserve.update(image_url: "http://happyhouse.me:81#{@event_reserve.event_images[0].image_url.to_s}") unless @event_reserve.event_images.blank?
        end
        
        if Rails.env == 'development'
          # @event_reserve.update(image_url: "http://192.168.0.4:3000#{@event.event_images[0].image_url.to_s}", event_url: event_url) unless @event.event_images.blank?
          format.html { redirect_to :action => "new" }
        else
          # @event_reserve.update(image_url: "http://happyhouse.me:81#{@event.event_images[0].image_url.to_s}", event_url: event_url) unless @event.event_images.blank?
          format.html { redirect_to :action => "new", :port => 81 }
        end
      else
        format.html { render :new }
        format.json { render json: @event_reserve.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_reserves/1
  # PATCH/PUT /event_reserves/1.json
  def update
    respond_to do |format|
      if @event_reserve.update(event_reserve_params)
        format.html { redirect_to @event_reserve, notice: 'Event reserve was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_reserve }
      else
        format.html { render :edit }
        format.json { render json: @event_reserve.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_reserves/1
  # DELETE /event_reserves/1.json
  def destroy
    @event_reserve.destroy
    respond_to do |format|
      format.html { redirect_to event_reserves_url, notice: 'Event reserve was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_reserve
      @event_reserve = EventReserve.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_reserve_params
      params[:event_reserve].permit(:event_site_id, :event_name, :event_url, :image_url, :discount, :price, :original_price, :show_flg, 
                                    :push_flg, :update_flg, :add_time, :close_time, :push, event_images_attributes: [:image])
    end
end
