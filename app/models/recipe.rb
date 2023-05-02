class Recipe < ApplicationRecord
    has_many :recipe_tags
    has_many :tags, :through => :recipe_tags

    has_many :recipe_ingredients
    has_many :ingredients, :through => :recipe_ingredients
end
