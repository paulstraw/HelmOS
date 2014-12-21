class Ship < ActiveRecord::Base
  belongs_to :captain, class_name: 'User'
  belongs_to :faction
  belongs_to :currently_orbiting, polymorphic: true

  before_validation :set_original_currently_orbiting, if: :new_record?

  validates :name, presence: true, uniqueness: {case_sensitive: false, scope: :faction_id}
  validates :captain, presence: true
  validates :faction, presence: true
  validates :currently_orbiting, presence: true

private
  def set_original_currently_orbiting
    self.currently_orbiting = faction.home_planet if faction.present?
  end
end
