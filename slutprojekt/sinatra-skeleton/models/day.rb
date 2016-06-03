class Day
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :mday, String
  property :wday, String
  belongs_to :week
  belongs_to :month
  belongs_to :year
  has n, :day_events
end