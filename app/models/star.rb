class Star < ActiveRecord::Base
  belongs_to :star_system

  has_many :planets
  has_many :satellites, through: :planets
  has_many :planets_connected_ships, through: :planets, source: :connected_ships
  has_many :satellites_connected_ships, through: :satellites, source: :connected_ships

  def class_name
    self.class.name
  end

  def channel_name
    "#{class_name}-#{id}"
  end

  def connected_ships
    return [planets_connected_ships + satellites_connected_ships].flatten
  end

  def name_hex_color
    Digest::MD5.hexdigest(name)[0..5]
  end

  def name_rgb_color
    name_hex_color.scan(/../).map {|c| c.hex}
  end
end
