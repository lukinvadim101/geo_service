class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :ip
      t.string :name
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
