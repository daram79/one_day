class DealSearchWordsController < ApplicationController
  before_action :set_deal_search_word, only: [:show, :edit, :update, :destroy]

  # GET /deal_search_words
  # GET /deal_search_words.json
  def index
    @deal_search_words = DealSearchWord.all
  end

  # GET /deal_search_words/1
  # GET /deal_search_words/1.json
  def show
  end

  # GET /deal_search_words/new
  def new
    @deal_search_word = DealSearchWord.new
  end

  # GET /deal_search_words/1/edit
  def edit
  end

  # POST /deal_search_words
  # POST /deal_search_words.json
  def create
    @deal_search_word = DealSearchWord.new(deal_search_word_params)

    respond_to do |format|
      if @deal_search_word.save
        format.html { redirect_to @deal_search_word, notice: 'Deal search word was successfully created.' }
        format.json { render :show, status: :created, location: @deal_search_word }
      else
        format.html { render :new }
        format.json { render json: @deal_search_word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deal_search_words/1
  # PATCH/PUT /deal_search_words/1.json
  def update
    respond_to do |format|
      if @deal_search_word.update(deal_search_word_params)
        format.html { redirect_to @deal_search_word, notice: 'Deal search word was successfully updated.' }
        format.json { render :show, status: :ok, location: @deal_search_word }
      else
        format.html { render :edit }
        format.json { render json: @deal_search_word.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def add_word
    DealSearchWord.create(word: params[:word])
    render json: {status: :ok}
  end

  # DELETE /deal_search_words/1
  # DELETE /deal_search_words/1.json
  def destroy
    @deal_search_word.destroy
    respond_to do |format|
      format.html { redirect_to deal_search_words_url, notice: 'Deal search word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deal_search_word
      @deal_search_word = DealSearchWord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deal_search_word_params
      params[:deal_search_word]
    end
end
