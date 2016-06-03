class Item
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  belongs_to :category
end