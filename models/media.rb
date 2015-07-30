require 'carrierwave/datamapper'
require 'rmagick'

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  version :thumb do
    process :resize_to_fill => [200,200]
  end

  storage :file
end

class Media
  include DataMapper::Resource
  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime

  property :caption, String, :required => false
  property :md5sum, String,   :length => 32, :default => lambda { |r, p| Digest::MD5.hexdigest(r.path.read) if r.path }
end

class Image < Media
  mount_uploader :image, ImageUploader
end

class Video < Media
  property :timestamp, DateTime, :required => false
  property :link, URI, :required => true
end
