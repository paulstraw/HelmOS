class Faction < ActiveRecord::Base
  validates :name, presence: true
  validates :home_planet, presence: true
  validates :hex_color, presence: true

  belongs_to :home_planet, class_name: 'Planet'
  has_many :ships

  def class_name
    self.class.name
  end

  def channel_name
    "#{class_name}.#{name}"
  end

  def system_channel_name(star_system)
    "#{star_system.class_name}.#{star_system.name}:#{channel_name}"
  end
end
