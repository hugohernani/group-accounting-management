require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'


class Media
  include DataMapper::Resource
  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime

  property :caption, String, :required => false
  property :path,   FilePath, :required => true
  property :md5sum, String,   :length => 32, :default => lambda { |r, p| Digest::MD5.hexdigest(r.path.read) if r.path }
end

Media.finalize

class Image < Media
end

Image.finalize

class Video < Media
  property :timestamp, DateTime, required => false
end

Video.finalize
