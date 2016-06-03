
class Year

  include DataMapper::Resource


  property :id, Serial
  property :year, String
  has n, :months
  has n, :weeks, :through => :months
  has n, :days, :through => :weeks

end