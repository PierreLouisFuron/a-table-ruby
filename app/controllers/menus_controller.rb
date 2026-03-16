class MenusController < ApplicationController

  before_action :set_menu, only: %i[ destroy ]

  def index
    @menus = Menu.ongoing

    # session[:menu_count] ||= 7
    # @recipes = []
    # ids = Recipe.pluck(:id)
    # (1..session[:menu_count]).each do
    #   @recipes << Recipe.find(ids.sample)
    # end
  end

  def create
    @menu = Menu.new(menu_params)
    respond_to do |format|
      (@menu.start_date..@menu.end_date).to_a.each do |date|
        @menu.meals << Meal.create(date: date)
      end
      if @menu.save
        format.html { redirect_to menus_path }
      else
        format.html { redirect_to menus_path, status: :unprocessable_entity }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_recipe_to_meal
    recipe = Recipe.find(params['recipe_id'])
    meal = Meal.find(params['meal_id'])
    meal.recipes << recipe
    respond_to do |format|
      format.html { render partial: "menus/recipe_item", locals: { meal: meal, recipe: recipe } }
      format.turbo_stream { render_meal_recipe_streams(meal, recipe) }
    end
  end

  def remove_recipe_from_meal
    recipe = Recipe.find(params['recipe_id'])
    meal = Meal.find(params['meal_id'])
    meal.recipes.delete(recipe)
    respond_to do |format|
      format.html { render partial: "menus/recipe_item", locals: { meal: meal, recipe: recipe } }
      format.turbo_stream { render_meal_recipe_streams(meal, recipe) }
    end
  end

  def update_meal
    meal = Meal.find(params['meal_id'])
    respond_to do |format|
      format.html { render partial: "meals/meal", locals: {meal: meal} }
    end
  end

  def update_menu_count
    if params[:menu_action] == 'increase'
        session[:menu_count] ||= 0
        session[:menu_count] += 1
    elsif params[:menu_action] == 'decrease'
        session[:menu_count] = [0, session[:menu_count].to_i - 1].max
    end

    redirect_to menus_path

    # if params[:menu][:action] == 'increase'
    #     session[:menu_count] ||= 0
    #     session[:menu_count] += 1
    # elsif params[:menu][:action] == 'decrease'
    #     session[:menu_count] = [0, session[:menu_count].to_i - 1].max
    # end

    # render json: { menu_count: session[:menu_count] }
  end

  def destroy
    @menu.destroy

    respond_to do |format|
      format.html { redirect_to menus_path}
      format.json { head :no_content }
    end
  end

  private

  def render_meal_recipe_streams(meal, recipe)
    menu = meal.menu
    menu_modal_id = "menu#{menu.id}IngredientsListModal"
    date_modal_id = "menu#{menu.id}Date#{meal.date}IngredientsListModal"

    render turbo_stream: [
      turbo_stream.replace("tft_meal_#{meal.id}_recipe_#{recipe.id}",
        partial: "menus/recipe_toggle", locals: { meal: meal, recipe: recipe }),
      turbo_stream.replace("#{menu_modal_id}List",
        partial: "shared/ingredients_list",
        locals: { ingredients: menu.all_ingredients, modal_id: menu_modal_id }),
      turbo_stream.replace("#{date_modal_id}List",
        partial: "shared/ingredients_list",
        locals: { ingredients: menu.all_ingredients_for_date(meal.date), modal_id: date_modal_id })
    ]
  end

  def set_menu
    @menu = Menu.find(params[:id])
  end

  def menu_params
    params.require(:menu).permit(:start_date, :end_date)
  end
end
