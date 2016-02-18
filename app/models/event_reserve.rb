class EventReserve < ActiveRecord::Base
  belongs_to  :event
  has_many :event_images, :dependent => :destroy
  accepts_nested_attributes_for :event_images, reject_if: :event_images_attributes.blank?#, allow_destroy: true
end
