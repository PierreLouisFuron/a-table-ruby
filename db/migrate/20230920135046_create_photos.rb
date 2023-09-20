class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.string :path, null: false
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :photos, :path, unique: true
  end
end
