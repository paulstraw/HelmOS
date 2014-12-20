class AddRadiusToStars < ActiveRecord::Migration
  def change
    add_column :stars, :radius, :integer, limit: 8
  end
end
