class CreateJoinTableMealRecipe < ActiveRecord::Migration[7.0]
  def change
    create_join_table :meals, :recipes do |t|
      t.index [:meal_id, :recipe_id]
      t.index [:recipe_id, :meal_id]
    end
  end
end
