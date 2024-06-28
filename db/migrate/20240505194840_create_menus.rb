class CreateMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :menus do |t|
      t.date :start_date, null: false
      t.date :end_date, null: false

      t.timestamps
    end
  end
end
