class Star < ActiveRecord::Base
  belongs_to :star_system

  has_many :planets
end
