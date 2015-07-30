class Group
  include DataMapper::Resource
  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime

  property :name, String
  property :description, String

  has n, :users, :required => true
end
