class EventReceiveUser < ActiveRecord::Base
  belongs_to :event_mailing_list, :foreign_key => :user_id
end
