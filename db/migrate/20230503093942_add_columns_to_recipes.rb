class AddColumnsToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :prep_time, :integer
    add_column :recipes, :cooking_time, :integer
  end
end
