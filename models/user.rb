class User
  include DataMapper::Resource
  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime

  property :username, String, :required => true, :length => 1..100
  property :password, BCryptHash, :required => true, :length => 1..100
  property :email, String, :required => true, :unique => true,
    :format => :email_address,
    :messages => {
      :presence  => "Email address is required",
      :is_unique => "This email address already exists.",
      :format    => "It doesn't look like a email address."
    }

  attr_accessor :password_confirmation

  #validations

  ## By convention the pattern is FIELD_NAME_confirmation.
  validates_confirmation_of :password, :confirm => :password_confirmation

  has 1, :profile, :required => false
  has n, :notifications, :child_key => [:posts],
         :via => :post, :required => false
  belongs_to :group, :required => false
end

class Profile
  include DataMapper::Resource
  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime

  property :first_name, String, :required => true, :length => 1..100
  property :second_name, String, :required => false, :length => 1..100
  property :birthday, Date, :required => false

  belongs_to :user
end
