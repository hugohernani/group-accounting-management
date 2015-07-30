require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'

class User
  include DataMapper::Resource
  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime

  property :username, String, :required => true, :length => 1..100
  property :password, String, :required => true, :length => 1..100
  property :email, String, :required => true, :unique => true,
    :format => :email_address,
    :messages => {
      :presence  => "Email address is required",
      :is_unique => "This email address already exists.",
      :format    => "It doesn't look like a email address."
    }

  attr_accessor :password_confirmation
  attr_accessor :email_repeated

  #validations
  validates_confirmation_of :password
  validates_confirmation_of :email, :confirm => :email_repeated

  has 1, :profile, :required => false
  has n, :posts, :required => false
  belongs_to :group, :required => false
end

User.finalize

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

Profile.finalize
