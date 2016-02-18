class EventImage < ActiveRecord::Base
  belongs_to  :event
  belongs_to  :event_reserve
  mount_uploader :image, ImageUploader
end
