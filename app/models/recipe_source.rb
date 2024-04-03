class RecipeSource < ApplicationRecord

  belongs_to :recipe
  belongs_to :source

  accepts_nested_attributes_for :source

end
