class Ship < ActiveRecord::Base
  belongs_to :captain, class_name: 'User'
  belongs_to :faction
  belongs_to :currently_orbiting, polymorphic: true
  delegate :star_system, to: :currently_orbiting

  before_validation :set_original_currently_orbiting, if: :new_record?

  validates :name, presence: true, uniqueness: {case_sensitive: false, scope: :faction_id}
  validates :captain, presence: true
  validates :faction, presence: true
  validates :currently_orbiting, presence: true

  def name_degrees
    Digest::MD5.hexdigest(name)[0..1].to_s.ljust(3, '0').to_i
  end

  def current_channel_names
    [
      faction.channel_name,
      faction.system_channel_name(star_system)
    ]
  end

  def name_hex_color
    Digest::MD5.hexdigest(name)[0..5]
  end

  def name_rgb_color
    name_hex_color.scan(/../).map {|c| c.hex}
  end

  # def can_subscribe?(channel_name)

  # end

private
  def set_original_currently_orbiting
    self.currently_orbiting = faction.home_planet if faction.present?
  end

  def set_original_cap_cur_ship

  end
end
