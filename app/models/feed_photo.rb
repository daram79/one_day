class FeedPhoto < ActiveRecord::Base
  belongs_to  :feed
  mount_uploader :image, ImageUploader
end
