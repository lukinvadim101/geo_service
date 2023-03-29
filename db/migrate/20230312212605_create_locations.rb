class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :ip, null: false
      t.string :name
      t.float :latitude
      t.float :longitude

      t.timestamps
      t.index :ip, unique: true
    end
  end
end
