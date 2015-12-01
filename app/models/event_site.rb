class EventSite < ActiveRecord::Base
  after_create :after_create_event_site
  
  def after_create_event_site
    event_users = EventMailingList.all
    event_users.each do |event_user|
      EventReceiveUser.create(user_id: event_user.id, user_email: event_user.email, event_site_id: self.id)
    end
  end
end
