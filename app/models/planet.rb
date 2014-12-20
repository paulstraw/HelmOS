class Planet < ActiveRecord::Base
  include OrbitalMechanics

  belongs_to :star

  validates :name, presence: true

  def name_hex_color
    Digest::MD5.hexdigest(name)[0..5]
  end

  def k_to(other_planet)
    # this is an intentionally naive calculation that doesn't take into account
    # current orbit position, etc
    (((apogee + perigee) / 2) - ((other_planet.apogee + other_planet.perigee) / 2)).abs
  end

  def s_to(other_planet)
    speed_modifier = 15 # this will eventually be pulled from the ship's engine info
    k_to(other_planet) / (UnitsOfMeasure::C_KPS * speed_modifier)
  end
end
