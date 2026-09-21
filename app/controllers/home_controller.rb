class HomeController < ApplicationController
  def index
    @upcoming_meals = Meal.upcoming
    @meals_of_the_day = Meal.on(Date.today)
    @meals_of_tomorrow = Meal.on(Date.tomorrow)
    @recipes_of_the_future = Recipe.joins(:meals).merge(Meal.after(Date.tomorrow)).distinct

    @quick_and_dirty_recipes = Recipe.joins(:tags)
                                     .where(tags: { name: %w[facile rapide] })
                                     .group('recipes.id')
                                     .having('COUNT(DISTINCT tags.id) = 2')
                                     .order('RANDOM()')
                                     .limit(5)
  end

  def refresh_quick_and_dirty_suggestions
    @quick_and_dirty_recipes = Recipe.joins(:tags)
                                     .where(tags: { name: %w[facile rapide] })
                                     .group('recipes.id')
                                     .having('COUNT(DISTINCT tags.id) = 2')
                                     .order('RANDOM()')
                                     .limit(5)
    render partial: 'recipe_suggestions'
  end

end
