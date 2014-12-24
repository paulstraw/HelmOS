class Planet < ActiveRecord::Base
  include OrbitalMechanics

  belongs_to :star
  delegate :star_system, to: :star

  validates :name, presence: true

  has_many :ships, as: :currently_orbiting
  has_many :connected_ships, -> {where(connected: true)}, class_name: 'Ship', as: :currently_orbiting

  has_many :satellites, as: :orbitable

  def class_name
    self.class.name
  end

  def channel_name
    "#{class_name}-#{id}"
  end

  def name_hex_color
    Digest::MD5.hexdigest(name)[0..5]
  end

  def name_rgb_color
    name_hex_color.scan(/../).map {|c| c.hex}
  end

  def name_degrees
    Digest::MD5.hexdigest(name)[0..1].to_s.ljust(3, '0').to_i
  end

  def kilometers_to(other_planet)
    # this is an intentionally naive calculation that doesn't take into account
    # current orbit position, etc
    (((apogee + perigee) / 2) - ((other_planet.apogee + other_planet.perigee) / 2)).abs
  end

  def seconds_to(other_planet)
    speed_modifier = 15 # this will eventually be pulled from the ship's engine info
    kilometers_to(other_planet) / (UnitsOfMeasure::C_KPS * speed_modifier)
  end
end
