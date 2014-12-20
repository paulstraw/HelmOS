class CreateStarSystems < ActiveRecord::Migration
  def change
    create_table :star_systems do |t|
      t.string :name

      t.timestamps
    end
  end
end
