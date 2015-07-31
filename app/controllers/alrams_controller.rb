class AlramsController < ApplicationController
  include ActionView::Helpers::DateHelper
  
  before_action :set_alram, only: [:show, :edit, :update, :destroy]

  # GET /alrams
  # GET /alrams.json
  def index
    search_start_time = (DateTime.now - 1).utc
    @alrams = Alram.where("user_id = ? and created_at > ?", params[:id], search_start_time).order("updated_at desc")
    @time_word = Hash.new
    @alrams.each do |alram|
      @time_word[alram.id] = time_ago_in_words(alram.created_at)
    end
    
#     @alrams = Alram.where("user_id: params[:id] and "user_id: params[:id], "created_at > '#{search_start_time - 1}'").order("updated_at desc")
  end

  # GET /alrams/1
  # GET /alrams/1.json
  def show
  end

  # GET /alrams/new
  def new
    @alram = Alram.new
  end

  # GET /alrams/1/edit
  def edit
  end

  # POST /alrams
  # POST /alrams.json
  def create
    @alram = Alram.new(alram_params)

    respond_to do |format|
      if @alram.save
        format.html { redirect_to @alram, notice: 'Alram was successfully created.' }
        format.json { render :show, status: :created, location: @alram }
      else
        format.html { render :new }
        format.json { render json: @alram.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alrams/1
  # PATCH/PUT /alrams/1.json
  def update
    respond_to do |format|
      if @alram.update(alram_params)
        format.html { redirect_to @alram, notice: 'Alram was successfully updated.' }
        format.json { render :show, status: :ok, location: @alram }
      else
        format.html { render :edit }
        format.json { render json: @alram.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alrams/1
  # DELETE /alrams/1.json
  def destroy
    @alram.destroy
    respond_to do |format|
      format.html { redirect_to alrams_url, notice: 'Alram was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def get_alram_data
    @alram = Alram.where(user_id: params[:user_id], send_flg: true).last
  end
  
  def phone_alram_on
    current_user = User.find(params[:user_id])
    current_user.alram_on = true
    current_user.save
    render :json => {alram_type: true}
  end
  
  def phone_alram_off
    current_user = User.find(params[:user_id])
    current_user.alram_on = false
    current_user.save
    render :json => {alram_type: false}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alram
      @alram = Alram.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def alram_params
      params[:alram]
    end
end
