class RecipeIngredient < ApplicationRecord

  belongs_to :recipe
  belongs_to :ingredient

  accepts_nested_attributes_for :ingredient

  before_create :append_to_end, if: -> { position.zero? }

  private

  # Records created outside the recipe form (console, seeds) go to the bottom.
  # Form submissions are renumbered by Recipe#reposition_ingredients instead.
  def append_to_end
    self.position = (recipe.recipe_ingredients.where.not(id: nil).maximum(:position) || -1) + 1
  end

end
