require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'

class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :description, Text
  property :created_at, DateTime
  property :updated_at, DateTime
  property :public, Boolean, :default

  has n, :sharing_with, :through => :userposts, :required => false
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

class UserPost
  include DataMapper::Resource
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :sharing_with, "User"
  belongs_to :post
end

UserPost.finalize

Post.finalize

class Supply < Post
  property :label, String
  property :price, Float
  property :bought_date, DateTime
  property :status, Enum[ :waiting, :in_progress, :done ]

end

Supply.finalize

class Chore < Post
	property :date_limit, DateTime
	property :priority, Enum[ :it_is_needed, :it_would_help, :just_do_it, :complete ]

  has n, :responsibles, "" :through => :userchores, :required => false
end

class UserChore
  include DataMapper::Resource
  property :created_at, DateTime
  property :updated_at, DateTime


  belongs_to :responsibles, "User"
  belongs_to :chore
end

UserChore.finalize

Chore.finalize

class Bill < Post
  property :value, Integer
  property :status, Enum[ :waiting, :in_debt, :paid ]
end

Bill.finalize


class Payment < Post
end

Payment.finalize
