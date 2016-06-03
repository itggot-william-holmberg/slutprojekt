class Week
  include DataMapper::Resource

  property :id, Serial
  property :week, Integer
  has n, :days
end