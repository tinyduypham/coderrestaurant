class FoodsController < ApplicationController
  before_action :set_food, only: [:show, :edit, :update, :destroy]

  # GET /foods
  # GET /foods.json
  def index
    @category = Food.Category
    @foods = get_foods
  end

  # GET /foods/1
  # GET /foods/1.json
  def show
    @category = Food.Category
    @selectedFood = Food.where(id: params[:id])
    @foods = get_foods
    @reviews = Review.where(food_id: params[:id]).order('updated_at DESC')
  end

  # GET /foods/new
  def new
    @food = Food.new
  end

  # GET /foods/1/edit
  def edit
  end

  # POST /foods
  # POST /foods.json
  def create
    @food = Food.new(food_params)

    respond_to do |format|
      if @food.save
        format.html { redirect_to @food, notice: 'Food was successfully created.' }
        format.json { render :show, status: :created, location: @food }
      else
        format.html { render :new }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /foods/1
  # PATCH/PUT /foods/1.json
  def update
    respond_to do |format|
      if @food.update(food_params)
        format.html { redirect_to @food, notice: 'Food was successfully updated.' }
        format.json { render :show, status: :ok, location: @food }
      else
        format.html { render :edit }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /foods/1
  # DELETE /foods/1.json
  def destroy
    @food.destroy
    respond_to do |format|
      format.html { redirect_to foods_url, notice: 'Food was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_food
      @food = Food.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def food_params
      params.require(:food).permit(:name, :desc, :price, :category, :image_url)
    end

    def get_foods
      query = nil
      if params[:category]
        query = "category like '%#{params[:category]}%'"
        params.delete(:search)  # don't want to search when user select category
      end

      if params[:search]
        query = "name like '%#{params[:search]}%'"
      end

      params[:sort] ||= 'name-asc'
      order = 'name ASC'
      if params[:sort] == 'name-desc'
        order = 'name DESC'
      end
      if params[:sort] == 'price-asc'
        order = 'price ASC'
      end
      if params[:sort] == 'price-desc'
        order = 'price DESC'
      end

      if query
        @foods = Food.where(query).order(order)
      else
        @foods = Food.all.order(order)
      end
    end
end
