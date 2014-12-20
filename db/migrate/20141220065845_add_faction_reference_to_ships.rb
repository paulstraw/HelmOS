class AddFactionReferenceToShips < ActiveRecord::Migration
  def change
    add_reference :ships, :faction, index: true
  end
end
