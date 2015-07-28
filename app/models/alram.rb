class Alram < ActiveRecord::Base
  belongs_to :user
  belongs_to :send_user, :foreign_key => "send_user_id", :class_name => "User"
  
  belongs_to :alram, :polymorphic => true
end
