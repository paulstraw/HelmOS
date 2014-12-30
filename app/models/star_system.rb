class StarSystem < ActiveRecord::Base
  validates :name, presence: true

  has_many :stars

  def class_name
    self.class.name
  end

  def channel_name
    "#{class_name}-#{id}"
  end

  def channel_names
    Faction.all.map do |faction|
      faction.system_channel_name(self)
    end
  end
end
