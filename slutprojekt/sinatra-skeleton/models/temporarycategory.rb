class TemporaryUserCategory
  include DataMapper::Resource

  belongs_to :temporary_user, :key => true
  belongs_to :category, :key => true
end
