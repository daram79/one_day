class EventDetailImage < ActiveRecord::Base
  belongs_to  :event_detail
  mount_uploader :image, ImageUploader  
end
