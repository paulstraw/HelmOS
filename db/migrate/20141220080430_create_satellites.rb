class CreateSatellites < ActiveRecord::Migration
  def change
    create_table :satellites do |t|
      t.string :name
      t.references :orbitable, polymorphic: true, index: true
      t.integer :apogee, limit: 8
      t.integer :perigee, limit: 8
      t.integer :radius, limit: 8

      t.timestamps
    end
  end
end
