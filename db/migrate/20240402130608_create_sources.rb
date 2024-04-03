class CreateSources < ActiveRecord::Migration[7.0]
  def change
    create_table :sources do |t|
      t.integer :source_type
      t.string :name

      t.timestamps
    end
  end
end
