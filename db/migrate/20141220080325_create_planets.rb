class CreatePlanets < ActiveRecord::Migration
  def change
    create_table :planets do |t|
      t.string :name
      t.integer :radius, limit: 8
      t.references :star, index: true
      t.integer :apogee, limit: 8
      t.integer :perigee, limit: 8

      t.timestamps
    end
  end
end
