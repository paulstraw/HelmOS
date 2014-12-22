class Faction < ActiveRecord::Base
  validates :name, presence: true
  validates :home_planet, presence: true
  validates :hex_color, presence: true

  belongs_to :home_planet, class_name: 'Planet'
end
