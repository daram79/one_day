class PopularsController < ApplicationController
  before_action :set_popular, only: [:show, :edit, :update, :destroy]

  # GET /populars
  # GET /populars.json
  def index
    # start_day = DateTime.now.prev_month
    # populars = Like.where("created_at > ?", start_day).group(:feed_id).order("count_feed_id desc").count(:feed_id)
    
    search_start_time = (DateTime.now - 1).utc
    populars = Like.where("created_at > ?", search_start_time).group(:feed_id).order("count_feed_id desc").count(:feed_id)
    
    feed_ids = populars.keys
    @populars = Feed.find(feed_ids) 
  end

  # GET /populars/1
  # GET /populars/1.json
  def show
  end

  # GET /populars/new
  def new
    @popular = Popular.new
  end

  # GET /populars/1/edit
  def edit
  end

  # POST /populars
  # POST /populars.json
  def create
    @popular = Popular.new(popular_params)

    respond_to do |format|
      if @popular.save
        format.html { redirect_to @popular, notice: 'Popular was successfully created.' }
        format.json { render :show, status: :created, location: @popular }
      else
        format.html { render :new }
        format.json { render json: @popular.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /populars/1
  # PATCH/PUT /populars/1.json
  def update
    respond_to do |format|
      if @popular.update(popular_params)
        format.html { redirect_to @popular, notice: 'Popular was successfully updated.' }
        format.json { render :show, status: :ok, location: @popular }
      else
        format.html { render :edit }
        format.json { render json: @popular.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /populars/1
  # DELETE /populars/1.json
  def destroy
    @popular.destroy
    respond_to do |format|
      format.html { redirect_to populars_url, notice: 'Popular was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_popular
      @popular = Popular.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def popular_params
      params[:popular]
    end
end
