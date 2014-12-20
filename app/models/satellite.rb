class Satellite < ActiveRecord::Base
  include OrbitalMechanics

  belongs_to :orbitable, polymorphic: true
end
