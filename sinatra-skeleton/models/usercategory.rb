class UserCategory
  include DataMapper::Resource

  belongs_to :user, :key => true
  belongs_to :category, :key => true
  belongs_to :day, :key => true
end
