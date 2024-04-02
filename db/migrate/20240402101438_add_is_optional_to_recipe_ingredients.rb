class AddIsOptionalToRecipeIngredients < ActiveRecord::Migration[7.0]
  def change
    add_column :recipe_ingredients, :is_optional, :boolean, default: false
  end
end
