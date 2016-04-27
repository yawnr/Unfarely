class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :code, unique: true, null: false
      t.string :name, unique: true
      t.string :search_string, unique: true, null: false
      t.integer :city_id, index: true

      t.timestamps null: false
    end
  end
end
