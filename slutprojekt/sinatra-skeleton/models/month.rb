
class Month

  include DataMapper::Resource


  property :id, Serial
  property :name, String

  belongs_to :year
  has n, :weeks
  has n, :days, :through => :weeks

end