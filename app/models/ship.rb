class Ship < ActiveRecord::Base
  belongs_to :captain, class_name: 'User'

  validates :name, presence: true, uniqueness: {case_sensitive: false, scope: :faction_id}
  validates :captain, presence: true
  validates :faction, presence: true
end
