class User
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :username, String, :length => 3..50
  property :password, BCryptHash
  property :email, String

  has n, :dayEvents
  has n, :days, :through => :dayEvents
  has n, :userCategory
  has n, :categories, :through => :userCategory
end