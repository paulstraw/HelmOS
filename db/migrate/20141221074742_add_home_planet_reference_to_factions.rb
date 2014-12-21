class AddHomePlanetReferenceToFactions < ActiveRecord::Migration
  def change
    add_reference :factions, :home_planet, index: true
  end
end
