class Star < ActiveRecord::Base
  belongs_to :star_system

  has_many :planets

  def name_hex_color
    Digest::MD5.hexdigest(name)[0..5]
  end
end
