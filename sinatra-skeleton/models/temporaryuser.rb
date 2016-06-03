class TemporaryUser
  include DataMapper::Resource

  property :id, Serial, :key => true


  has n, :temporaryUserCategory
  has n, :categories, :through => :temporaryUserCategory
end