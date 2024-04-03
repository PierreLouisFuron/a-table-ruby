class CreateRecipeSources < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_sources do |t|
      t.string :details
      t.belongs_to :recipe, null: false, foreign_key: true
      t.belongs_to :source, null: false, foreign_key: true

      t.timestamps
    end
  end
end
