class AddHexColorToFactions < ActiveRecord::Migration
  def change
    add_column :factions, :hex_color, :string
  end
end
