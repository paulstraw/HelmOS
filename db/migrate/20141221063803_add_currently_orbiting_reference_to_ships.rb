class AddCurrentlyOrbitingReferenceToShips < ActiveRecord::Migration
  def change
    add_reference :ships, :currently_orbiting, polymorphic: true

    add_index :ships, [:currently_orbiting_id, :currently_orbiting_type], name: 'index_ships_on_cur_orbiting_id_and_cur_orbiting_type'
  end
end
