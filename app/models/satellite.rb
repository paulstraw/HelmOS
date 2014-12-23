class Satellite < ActiveRecord::Base
  include OrbitalMechanics

  has_many :ships, as: :currently_orbiting
  has_many :connected_ships, -> {where(connected: true)}, class_name: 'Ship', as: :currently_orbiting

  belongs_to :orbitable, polymorphic: true
  delegate :star, to: :orbitable
  delegate :star_system, to: :orbitable

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
end
