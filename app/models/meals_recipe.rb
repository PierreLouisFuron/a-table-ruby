class MealsRecipe < ApplicationRecord

  belongs_to :meal
  belongs_to :recipe
end
