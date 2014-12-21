class Satellite < ActiveRecord::Base
  include OrbitalMechanics

  has_many :ships, as: :currently_orbiting

  belongs_to :orbitable, polymorphic: true
end
