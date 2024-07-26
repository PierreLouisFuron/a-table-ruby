class HomeController < ApplicationController
  def index
    @meals_of_the_day = todays_meals
    @meals_of_tomorrow = tomorrows_meals
    @recipes_of_the_future = future_recipes
  end

  private

  def todays_meals
    Meal.where(date: DateTime.now)
  end

  def tomorrows_meals
    Meal.where(date: DateTime.tomorrow)
  end

  def future_recipes
    Recipe.joins(:meals).where('meals.date > ?', DateTime.tomorrow)
  end

end
