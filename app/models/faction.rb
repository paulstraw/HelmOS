class Faction < ActiveRecord::Base
  validates :name, presence: true
end
