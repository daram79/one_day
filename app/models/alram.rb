require 'json'
class Alram < ActiveRecord::Base
  belongs_to :user
  belongs_to :send_user, :foreign_key => "send_user_id", :class_name => "User"
  
  belongs_to :alram, :polymorphic => true
  
  after_create :after_create_alram
  
  def after_create_alram
    Thread.new do
      break_flg = 0
      gcm = GCM.new("AIzaSyDyxck6hFnEtoBkTz3FNdvme3w3csLdTWA")
      registration_id = User.where(id: self.user_id).pluck(:registration_id)
      num = 0
      loop{
        num += 1
        break if num > 3
        response = gcm.send(registration_id)
        break_flg = JSON.parse(response[:body])["success"]
        break if break_flg == 1
      }
      self.update(send_flg: true) if break_flg == 1
    end
  end
end