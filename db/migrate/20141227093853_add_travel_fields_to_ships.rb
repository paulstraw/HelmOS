class AddTravelFieldsToShips < ActiveRecord::Migration
  def change
    add_reference :ships, :travelling_to, polymorphic: true, index: true
    add_column :ships, :travelling, :boolean, default: false, null: false
    add_column :ships, :travel_ends_at, :datetime
  end
end
