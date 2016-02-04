class PpomppusController < ApplicationController
  before_action :set_ppomppu, only: [:show, :edit, :update, :destroy]

  # GET /ppomppus
  # GET /ppomppus.json
  def index
    # @ppomppus = Ppomppu.all
    @ppomppus = Ppomppu.order("id desc").limit(100)
  end

  # GET /ppomppus/1
  # GET /ppomppus/1.json
  def show
  end

  # GET /ppomppus/new
  def new
    @ppomppu = Ppomppu.new
  end

  # GET /ppomppus/1/edit
  def edit
  end

  # POST /ppomppus
  # POST /ppomppus.json
  def create
    @ppomppu = Ppomppu.new(ppomppu_params)

    respond_to do |format|
      if @ppomppu.save
        format.html { redirect_to @ppomppu, notice: 'Ppomppu was successfully created.' }
        format.json { render :show, status: :created, location: @ppomppu }
      else
        format.html { render :new }
        format.json { render json: @ppomppu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ppomppus/1
  # PATCH/PUT /ppomppus/1.json
  def update
    respond_to do |format|
      if @ppomppu.update(ppomppu_params)
        format.html { redirect_to @ppomppu, notice: 'Ppomppu was successfully updated.' }
        format.json { render :show, status: :ok, location: @ppomppu }
      else
        format.html { render :edit }
        format.json { render json: @ppomppu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ppomppus/1
  # DELETE /ppomppus/1.json
  def destroy
    @ppomppu.destroy
    respond_to do |format|
      format.html { redirect_to ppomppus_url, notice: 'Ppomppu was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ppomppu
      @ppomppu = Ppomppu.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ppomppu_params
      params[:ppomppu]
    end
end
