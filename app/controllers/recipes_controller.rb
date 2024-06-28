class RecipesController < ApplicationController

  include Pagy::Backend
  before_action :set_recipe, only: %i[ show edit update destroy ]

  def destroy_image
    @recipe = Recipe.find(params[:recipe_id])
    @image = @recipe.images.find(params[:id])
    @image.purge

    redirect_to recipe_images_path(@recipe), notice: 'Image was successfully deleted.'
  end

  def search
    @recipes = if params[:query].present?
      Recipe.where("name ILIKE ?", "%#{params[:query]}%")
    else
      Recipe.all
    end
    @meal = if params[:meal_id].present?
      Meal.find(params[:meal_id])
    else
      nil
    end
    respond_to do |format|
      # format.turbo_stream { render partial: "home/recipes", locals: { recipes: @recipes } }
      format.html { render partial: "menus/recipes", locals: { recipes: @recipes, meal: @meal } }
    end
  end

  # GET /recipes or /recipes.json
  def index
    if params[:search]
      search_options = {
        include_recipes: params.has_key?(:include_recipes),
        include_ingredients: params.has_key?(:include_ingredients),
        include_tags: params.has_key?(:include_tags),
        include_sources: params.has_key?(:include_sources),
      }
      @pagy, @recipes = pagy(Recipe.search(params[:search], search_options))
    else
      @pagy, @recipes = pagy(Recipe.all)
    end
  end

  # GET /recipes/1 or /recipes/1.json
  def show
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes or /recipes.json
  def create
    create_new_tags
    @recipe = Recipe.new(recipe_params)
    respond_to do |format|
      @recipe.prep_time = ((params[:prep_time_days].to_i * 24) + params[:prep_time_hours].to_i) * 60 + params[:prep_time_minutes].to_i
      @recipe.cooking_time = ((params[:cooking_time_days].to_i * 24) + params[:cooking_time_hours].to_i) * 60 + params[:cooking_time_minutes].to_i
      if @recipe.save
        format.html { redirect_to recipe_url(@recipe), notice: "Recipe was successfully created." }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1 or /recipes/1.json
  def update
    create_new_tags
    respond_to do |format|
      @recipe.prep_time = ((params[:prep_time_days].to_i * 24) + params[:prep_time_hours].to_i) * 60 + params[:prep_time_minutes].to_i
      @recipe.cooking_time = ((params[:cooking_time_days].to_i * 24) + params[:cooking_time_hours].to_i) * 60 + params[:cooking_time_minutes].to_i
      if @recipe.update(recipe_params)
        format.html { redirect_to recipe_url(@recipe), notice: "Recipe was successfully updated." }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1 or /recipes/1.json
  def destroy
    @recipe.destroy

    respond_to do |format|
      format.html { redirect_to recipes_url, notice: "Recipe was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def create_new_tags
      if params[:recipe][:tag_ids]
        params[:recipe][:tag_ids].each_with_index do |tag_param, index|
          if tag_param.to_i == 0 && tag_param != ''
            tag = Tag.find_or_create_by(name: tag_param.downcase)
            params[:recipe][:tag_ids][index] = tag.id
          end
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.require(:recipe).permit(
        :name,
        :description,
        :servings,
        images: [],
        tag_ids: [],
        recipe_ingredients_attributes: [
          :quantity,
          :unit,
          :is_optional,
          :_destroy,
          :id,
          ingredient_attributes: [ :name ]
        ],
        recipe_sources_attributes: [
          :details,
          :_destroy,
          :id,
          source_attributes: [
            :name,
            :source_type
          ]
        ]
      )
    end
end
