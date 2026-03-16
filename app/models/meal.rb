class Meal < ApplicationRecord

  has_and_belongs_to_many :recipes
  belongs_to :menu

  def all_ingredients
    ingredients = []

    self.recipes.each do |recipe|
      recipe.ingredients.each do |ingredient|
        ingredients << ingredient
      end
    end
    ingredients
  end
end
