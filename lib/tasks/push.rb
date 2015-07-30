#encoding: utf-8
# require 'gcm'
# require "/Users/shimtong1004/work/shopping_note/config/environment.rb"
# gcm = GCM.new("AIzaSyDyxck6hFnEtoBkTz3FNdvme3w3csLdTWA")
# # you can set option parameters in here
# #  - all options are pass to HTTParty method arguments
# #  - ref: https://github.com/jnunemaker/httparty/blob/master/lib/httparty.rb#L40-L68
# #  gcm = GCM.new("my_api_key", timeout: 3)
# # an array of one or more client registration IDs
# registration_ids = ["APA91bGzgf0igOh3MaZ0CuMAxPAmjdtgZxv38zDfcBLWB5cSl8m-wIzTiD9osRfkHjQxUG-xR5h8slohF_cARwduUUUmO2OBHfQR11OB4wH1P7s7OYakhxmjrODNR-LRAPIJgbYofZ7e"]
# options = {data: {friend_user_name: "심희동", alram_type: "Like"}}
# # options = {type: "Like", friend_user_name: "aaa"}
# response = gcm.send(registration_ids, options)
# p response

require 'gcm'
require "#{File.dirname(__FILE__)}/../../config/environment.rb"
while true do
  alrams = Alram.where(send_flg: false)
  registration_id = Alram.where(send_flg: false).group(:user_id).includes(:user).pluck(:registration_id)
  registration_id.compact
  unless registration_id.blank?
    gcm = GCM.new("AIzaSyDyxck6hFnEtoBkTz3FNdvme3w3csLdTWA")
    response = gcm.send(registration_id)
    alrams.update_all(send_flg: true)
  end
end
# puts "push start " + Time.now.to_s
# alrams = Alram.where(send_flg: false)
# registration_id = Alram.where(send_flg: false).group(:user_id).includes(:user).pluck(:registration_id)
# registration_id.compact
# unless registration_id.blank?
  # gcm = GCM.new("AIzaSyDyxck6hFnEtoBkTz3FNdvme3w3csLdTWA")
  # response = gcm.send(registration_id)
  # alrams.update_all(send_flg: true)
# end
# puts "push start " + Time.now.to_s