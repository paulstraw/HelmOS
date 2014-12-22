class Satellite < ActiveRecord::Base
  include OrbitalMechanics

  has_many :ships, as: :currently_orbiting

  belongs_to :orbitable, polymorphic: true

  def name_hex_color
    Digest::MD5.hexdigest(name)[0..5]
  end

  def name_degrees
    Digest::MD5.hexdigest(name)[0..1].to_s.ljust(3, '0').to_i
  end
end
