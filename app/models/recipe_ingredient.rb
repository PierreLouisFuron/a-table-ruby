class RecipeIngredient < ApplicationRecord

  belongs_to :recipe
  belongs_to :ingredient

  accepts_nested_attributes_for :ingredient

  def display_ingredient_name
    (quantity.present? || unit.present?) ? name = "#{self.ingredient.name.capitalize} : #{self.quantity} #{self.unit}" : name = self.ingredient.name.capitalize
    self.is_optional ? "( #{name} )" : name
  end
end
