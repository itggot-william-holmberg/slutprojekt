class DayEvent
  include DataMapper::Resource

  property :id, Serial

  belongs_to :day, :key => true
  belongs_to :event, :key => true
  belongs_to :user, :key => true
end
