class Ship < ActiveRecord::Base
  belongs_to :captain, class_name: 'User'
  belongs_to :faction
  belongs_to :currently_orbiting, polymorphic: true
  belongs_to :travelling_to, polymorphic: true
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
    speed_modifier = 20 # this will eventually be pulled from the ship's engine info
    actual_time = kilometers_to(destination) / (UnitsOfMeasure::C_KPS * speed_modifier)

    # minimum travel time is 5 seconds
    [5, actual_time].max
  end

  def can_travel_to?(destination)
    return "You are currently in travel" if travelling
    return "You are already at #{destination.name}" if currently_orbiting == destination
    return true
  end

  def begin_travel_to(destination)
    # we can't begin travel if we're already travelling
    return if travelling

    time_to_run = seconds_to(destination).seconds.from_now

    self.travelling_to = destination
    self.travel_ends_at = time_to_run
    self.travelling = true
    save!

    self.delay(run_at: time_to_run).complete_travel

    WebsocketRails.users[captain.id].send_message('travel_started', self.as_json(
      methods: [:current_channel_names],
      include: [:travelling_to]
    ))
  end

  def complete_travel
    # we can't complete travel if we're not currently travelling
    return unless travelling && travelling_to.present?

    self.currently_orbiting = travelling_to
    self.travelling_to = nil
    self.travel_ends_at = nil
    self.travelling = false
    save!

    WebsocketRails.users[captain.id].send_message('travel_ended', self.as_json(
      methods: [:current_channel_names],
      include: [:travelling_to]
    ))
  end

private
  def set_original_currently_orbiting
    self.currently_orbiting = faction.home_planet if faction.present?
  end

  def set_original_cap_cur_ship

  end
end
