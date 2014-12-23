class Star < ActiveRecord::Base
  belongs_to :star_system

  has_many :planets

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
end
