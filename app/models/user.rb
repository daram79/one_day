class User < ActiveRecord::Base
  has_many :feeds
  has_many :likes
  has_many :alrams
  has_many :send_user_alrams, :foreign_key => "send_user_id", :class_name => "Alram"
  has_many :comments
  
  def self.get_nick
    f_nick = UserFirstNick.offset(rand(UserFirstNick.count)).first
    s_nick = UserSecondNick.offset(rand(UserSecondNick.count)).first
    nick = f_nick.nick + " " + s_nick.nick
  end
end
