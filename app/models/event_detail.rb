class EventDetail < ActiveRecord::Base
  has_many :event_detail_images, :dependent => :destroy
  
  accepts_nested_attributes_for :event_detail_images, reject_if: :event_detail_images_attributes.blank?#, allow_destroy: true
end
