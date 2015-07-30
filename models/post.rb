# Notification
class Notification
  include DataMapper::Resource

  # if it is null, the associated message has not been read yet
  property :read, DateTime, required: false

  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :user, :key => true
  belongs_to :post, :key => true
end


class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :description, Text
  property :created_at, DateTime
  property :updated_at, DateTime
  property :public, Boolean

  has n, :notifications, :child_key => [:sharing_with],
         :via => :user, :required => false
  has 1, :media, :required => false

  #validations
  validates_with_method :public, :method => :check_sharings

  def check_sharings
    unless self.notifications.empty?
      self.public = true
    else
      self.public = false
    end
  end

end

class Supply < Post
  property :label, String
  property :price, Float
  property :bought_date, DateTime
  property :status, Enum[ :waiting, :in_progress, :done ], :default => :waiting

end

class UserChoreResponsibility
  include DataMapper::Resource
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :user, :key => true
  belongs_to :chore, :key => true
end

class Chore < Post
	property :date_limit, DateTime
	property :priority, Enum[ :it_would_help, :it_is_needed, :just_do_it, :complete ], :default => :it_would

  has n, :user_chore_responsibilities, :via => :user,
         :child_key => [:responsibles], :required => true
end

class UserBill
  include DataMapper::Resource
  property :created_at, DateTime
  property :updated_at, DateTime

  property :status_type, Enum[:debtor, :collector], :default => :debtor # Is it a good idea to have a default?

  belongs_to :user, :key => true
  belongs_to :bill, :key => true
end

class Bill < Post
  property :value, Integer
  property :status, Enum[ :waiting, :in_debt, :paid ], :default => :waiting

  has n, :user_bills, :via => :user,
         :child_key => [:bill_responsibles], :required => true

end

class Payment < Post

  property :period_type, Enum[:daily, :weekly, :fortnightly, :monthly,
                         :quarterly, :semiannually, :annually, :other]
  property :value, Integer
  property :initial_date, DateTime, :required => false
  property :limit_date, DateTime, :required => false

  # TODO Lots of other fields.
  
end
