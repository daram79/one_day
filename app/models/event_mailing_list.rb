class EventMailingList < ActiveRecord::Base
  has_many :event_receive_users, :foreign_key => :user_id
  
  after_create :after_create_email
  before_destroy :before_destroy_email
  
  def after_create_email
    event_sites = EventSite.all
    event_sites.each do |event_site|
      EventReceiveUser.create(user_id: self.id, user_email: self.email, event_site_id: event_site.id)
    end
  end
  
  def before_destroy_email
    self.event_receive_users.destroy_all
  end
end
