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

  def authorized_for_channel?(channel_name)
    # Faction.United Republic
    # StarSystem.Sol:Faction.United Republic

    authorized = false

    # StarSystem.Sol:Faction.United Republic -> ['StarSystem.Sol', 'Faction.United Republic']
    channel_model_instances = channel_name.split(':').map do |channel_segment|
      # StarSystem.Sol -> ['StarSystem', 'Sol']
      split_channel_segment = channel_segment.split('.')

      # 'StarSystem' -> StarSystem
      channel_segment_class = Object.const_get split_channel_segment[0]

      # StarSystem.find_by(name: 'Sol')
      channel_segment_class.find_by(name: split_channel_segment[1])
    end

    if channel_model_instances.count == 2 && channel_model_instances.first.is_a?(StarSystem) && channel_model_instances.last.is_a?(Faction)
      # StarSystem.Sol:Faction.United Republic
      if star_system == channel_model_instances.first && faction == channel_model_instances.last
        authorized = true
      end
    elsif channel_model_instances.count == 1 && channel_model_instances.first.is_a?(Faction)
      # Faction.United Republic
      if faction == channel_model_instances.first
        authorized = true
      end
    end

    return authorized
  end

  def kilometers_to(destination)
    # this is an intentionally naive calculation that doesn't take into account
    # current orbit position, etc
    currently_orbiting_distance = (currently_orbiting.apogee + currently_orbiting.perigee) / 2
    destination_distance = (destination.apogee + destination.perigee) / 2

    if currently_orbiting.is_a? Satellite
      currently_orbiting_distance = currently_orbiting_distance + ((currently_orbiting.orbitable.apogee + currently_orbiting.orbitable.perigee) / 2)
    end

    if destination.is_a? Satellite
      destination_distance = destination_distance + ((destination.orbitable.apogee + destination.orbitable.perigee) / 2)
    end

    (currently_orbiting_distance - destination_distance).abs
  end

  def seconds_to(destination)
    speed_modifier = 15 # this will eventually be pulled from the ship's engine info
    kilometers_to(destination) / (UnitsOfMeasure::C_KPS * speed_modifier)
  end

  def begin_travel_to(destination)
    time_to_run = seconds_to(destination).seconds_from_now

    delay(run_at: time_to_run).complete_travel_to(destination)
  end

  def complete_travel_to(destination)

  end

private
  def set_original_currently_orbiting
    self.currently_orbiting = faction.home_planet if faction.present?
  end

  def set_original_cap_cur_ship

  end
end
