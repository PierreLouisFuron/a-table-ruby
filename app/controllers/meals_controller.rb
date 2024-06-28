class MealsController < ApplicationController

  before_action :set_menu

  def create
    @meal = @menu.meals.new(meal_params)
    respond_to do |format|
      if @meal.save
        format.html { redirect_to menus_path }
      else
        format.html { redirect_to menus_path, status: :unprocessable_entity }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_menu
    @menu = Menu.find(params[:menu])
  end

  def meal_params
    params.require(:meal).permit(:date)
  end

end
