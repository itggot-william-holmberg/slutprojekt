class Event
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :dayEvents

end




