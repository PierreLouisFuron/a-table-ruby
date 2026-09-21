class AddPositionToRecipeIngredients < ActiveRecord::Migration[7.0]
  def up
    add_column :recipe_ingredients, :position, :integer, default: 0, null: false
    add_index :recipe_ingredients, [:recipe_id, :position]

    # Backfill: keep the current (id) ordering as the initial position.
    execute <<~SQL
      UPDATE recipe_ingredients
      SET position = numbered.row_number - 1
      FROM (
        SELECT id, ROW_NUMBER() OVER (PARTITION BY recipe_id ORDER BY id) AS row_number
        FROM recipe_ingredients
      ) AS numbered
      WHERE recipe_ingredients.id = numbered.id
    SQL
  end

  def down
    remove_index :recipe_ingredients, [:recipe_id, :position]
    remove_column :recipe_ingredients, :position
  end
end
