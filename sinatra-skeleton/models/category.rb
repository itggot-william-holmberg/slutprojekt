class Category
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :items
  has n, :userCategories
end