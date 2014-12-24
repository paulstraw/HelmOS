class Message < ActiveRecord::Base
  belongs_to :ship

  validates :ship, presence: true
  validates :channel_name, presence: true
  validates :content, presence: true
end
