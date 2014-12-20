module OrbitalMechanics
  # http://www.orbiter-forum.com/showthread.php?t=26682
  extend ActiveSupport::Concern

  # http://www.yaldex.com/games-programming/0672323699_ch13lev1sec3.html
  # G is the gravitational constant of the universe equal to 6.67x10-11 N*m2 * kg -2. Also, the masses must be in kilograms and the distance r in meters. Say that you want to find out what the gravitational attraction is between two average sized people of 70 kg (155 lbs.) at a distance of 1 meter:
  # F = 6.67e-11 * 70kg * 70kg / (1 m)^2 = 3.26x10-7 N

  # F = G * m1 * m2 / R^2
  GRAVITATIONAL_CONSTANT = 6.67259e-11
  EARTH_MASS = 5.972e24

  included do

  end

  def orbitable_radius
    send(self.respond_to?(:star) ? :star : :orbitable).radius
  end

  def orbitable_mass
    9.363436814E20 * send(self.respond_to?(:star) ? :star : :orbitable).radius
  end

  def mass
    # TODO this is not correct
    # 5.972E24 / 6378 = 9.363436814E20
    9.363436814E20 * radius
  end

  def apogee_radius
    BigDecimal.new(apogee + orbitable_radius)
  end

  def perigee_radius
    BigDecimal.new(perigee + orbitable_radius)
  end

  def semi_major_axis
    (apogee_radius + perigee_radius) / 2
  end

  def eccentricity
    (apogee_radius - perigee_radius) / (apogee_radius + perigee_radius)
  end

  def gmgm
    # TODO something is really broken here
    # GRAVITATIONAL_CONSTANT * orbitable_mass * mass / (((apogee_radius + perigee_radius) / 2) ** -2)
    GRAVITATIONAL_CONSTANT * orbitable_mass * mass / (((apogee_radius + perigee_radius) / 2) ** 2)
  end

  def mean_motion
    Math.sqrt(gmgm / semi_major_axis ** 3)
  end

  def orbital_period
    2 * Math::PI * Math.sqrt(semi_major_axis ** 3 / gmgm)
  end
end