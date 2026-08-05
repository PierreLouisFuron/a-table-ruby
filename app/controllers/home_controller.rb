class HomeController < ApplicationController
  def index
    @upcoming_meals = Meal.upcoming
    @meals_of_the_day = Meal.on(Date.today)
    @meals_of_tomorrow = Meal.on(Date.tomorrow)
    @recipes_of_the_future = Recipe.joins(:meals).merge(Meal.after(Date.tomorrow)).distinct
  end

end
