class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :description, Text
  property :created_at, DateTime
  property :updated_at, DateTime
  property :public, Boolean

  has n, :users, :child_key => [:sharing_with], :required => false
  has 1, :media, :required => false

  #validations
  validates_with_method :public, :method => :check_sharings

  def check_sharings
    unless self.sharing_with.empty?
      self.public = true
    else
      self.public = false
    end
  end

end

# class UserPost
#   include DataMapper::Resource
#   property :created_at, DateTime
#   property :updated_at, DateTime
#
#   belongs_to :sharing_with, "User"
#   belongs_to :post
# end

class Supply < Post
  property :label, String
  property :price, Float
  property :bought_date, DateTime
  property :status, Enum[ :waiting, :in_progress, :done ]

end

class Chore < Post
	property :date_limit, DateTime
	property :priority, Enum[ :it_is_needed, :it_would_help, :just_do_it, :complete ]

  has n, :users, :child_key => [:responsibles], :required => true
end

# class UserChore
#   include DataMapper::Resource
#   property :created_at, DateTime
#   property :updated_at, DateTime
#
#
#   belongs_to :users, :child_key => [:responsibles]
#   belongs_to :chore
# end

class Bill < Post
  property :value, Integer
  property :status, Enum[ :waiting, :in_debt, :paid ]
end

class Payment < Post
end
