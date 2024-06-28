class CreateMeals < ActiveRecord::Migration[7.0]
  def change
    create_table :meals do |t|
      t.date :date
      t.references :menu, null: false, foreign_key: true

      t.timestamps
    end
  end
end
