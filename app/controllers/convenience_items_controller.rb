#encoding: utf-8
class ConvenienceItemsController < ApplicationController
  before_action :set_convenience_item, only: [:show, :edit, :update, :destroy]

  # GET /convenience_items
  # GET /convenience_items.json
  def index    
    if params[:item_type] == "11"
      @item_type = "1+1"
    elsif params[:item_type] == "21"
      @item_type = "2+1"
    elsif params[:item_type] == "gift"
      @item_type = "gift"
    end
    
    title_back = @item_type
    title_back = "증정행사" if @item_type == "gift"
    
    session[:conveni_name] = params[:conveni_name] if params[:conveni_name]
    
    if session[:conveni_name] == "gs25"
      @title = "GS25 " + title_back
    elsif session[:conveni_name] == "cu"
      @title = "CU " + title_back
    elsif session[:conveni_name] == "seven_eleven"
      @title = "7-ELEVEN" + title_back
    elsif session[:conveni_name] == "mini_stop"
      @title = "미니스톱" + title_back
    end
    
    # @convenience_items = ConvenienceItem.where("conveni_name = ? and item_type= ? ", session[:conveni_name], @item_type)
    start_date = Time.now.beginning_of_month
    end_at = Time.now.end_of_month
    @convenience_items = ConvenienceItem.where("conveni_name = ? and item_type= ? and created_at between ? and ? ", session[:conveni_name], @item_type, start_date, end_at)
    
    @half_cnt = @convenience_items.size/2
    @table_index = []
    for i in 0..@half_cnt - 1
      @table_index.push i * 2 
    end
    
    @is_even = false
    @is_even = true if @convenience_items.size % 2 == 1
    
    @image_size = 100
    @image_size = 80 if session[:conveni_name] == "seven_eleven" 
  end

  # GET /convenience_items/1
  # GET /convenience_items/1.json
  def show
  end

  # GET /convenience_items/new
  def new
    @convenience_item = ConvenienceItem.new
  end

  # GET /convenience_items/1/edit
  def edit
  end

  # POST /convenience_items
  # POST /convenience_items.json
  def create
    @convenience_item = ConvenienceItem.new(convenience_item_params)
    # @convenience_item = ConvenienceItem.new(convenience_item_params.merge(start_at: Time.now, end_at: Time.now.end_of_month))
    
    params.require(:convenience_item).permit(:start_at).merge(user_id: current_user.id)

    respond_to do |format|
      if @convenience_item.save
        format.html { redirect_to @convenience_item, notice: 'Convenience item was successfully created.' }
        format.json { render :show, status: :created, location: @convenience_item }
      else
        format.html { render :new }
        format.json { render json: @convenience_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /convenience_items/1
  # PATCH/PUT /convenience_items/1.json
  def update
    respond_to do |format|
      if @convenience_item.update(convenience_item_params)
        format.html { redirect_to @convenience_item, notice: 'Convenience item was successfully updated.' }
        format.json { render :show, status: :ok, location: @convenience_item }
      else
        format.html { render :edit }
        format.json { render json: @convenience_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /convenience_items/1
  # DELETE /convenience_items/1.json
  def destroy
    @convenience_item.destroy
    respond_to do |format|
      format.html { redirect_to convenience_items_url, notice: 'Convenience item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_convenience_item
      @convenience_item = ConvenienceItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def convenience_item_params
      params[:convenience_item]
    end
end
