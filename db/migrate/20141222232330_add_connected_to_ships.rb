class AddConnectedToShips < ActiveRecord::Migration
  def change
    add_column :ships, :connected, :boolean, default: false, null: false
  end
end
