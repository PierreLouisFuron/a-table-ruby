class Meal < ApplicationRecord

  has_and_belongs_to_many :recipes
  belongs_to :menu

  def all_ingredients
    recipes.flat_map(&:ingredients).uniq
  end
end
