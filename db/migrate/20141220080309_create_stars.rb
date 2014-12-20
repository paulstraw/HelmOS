class CreateStars < ActiveRecord::Migration
  def change
    create_table :stars do |t|
      t.string :name
      t.integer :x, limit: 8
      t.integer :y, limit: 8
      t.references :star_system, index: true

      t.timestamps
    end
  end
end
