#encoding: utf-8
class Ppomppu < ActiveRecord::Base
  after_create :send_ppom_push  
  
  def send_ppom_push
    gcm = GCM.new("AIzaSyD_3jJfuO8NT8G-kDHcmTiwl3w0W1JuxXQ")
    event_user_id = EventMailingList.find_by_email("shimtong1004@gmail.com").id
    registration_ids = EventUserRegistrations.where(event_user_id: event_user_id).pluck(:registration_id)
    option = { :data => { 'message' => "뽐뿌에 이벤트가 올라왔습니다. ***#{self.url}" } }   
    
    registration_ids.uniq!
    unless registration_ids.blank?
      begin
        response = gcm.send(registration_ids, option)
        Ppomppu.send_ppom_push_check_button(response, registration_ids)
      rescue => e
        pp e.backtrace
        
      end
    end
  end
  
  def self.send_ppom_push_check_button(response, registration_ids)
    loop_flg = true
    loop_flg = false if JSON.parse(response[:body])["failure"] == 0
    while loop_flg
      rr = JSON.parse(response[:body])["results"]
      
      delete_ids = response[:not_registered_ids]
      update_ids = []
      success_ids = []
      
      rr.each_with_index do |r, i|
        update_hash = Hash.new
        if r.key?("error") && r.value?("NotRegistered")
          # delete_ids.push registration_ids[i]
        elsif r.key?("error") && r.value?("InvalidRegistration")
          # delete_id_index.push i
          delete_ids.push registration_ids[i]
        elsif r.key?("message_id") && r.key?("registration_id")
          update_hash[:old] = registration_ids[i]
          update_hash[:new] = r["registration_id"]
          update_ids.push(update_hash)
          # delete_id_index.push i
        elsif r.key?("error") && r.value?("Unavailable")
          #전송 실패한 아이디는 다시 전송
        elsif r.key?("message_id") && r.size == 1
          success_ids.push registration_ids[i]
          # update_id_index.push i
        end
      end
          
      #푸쉬에 성공한 registration_id 배열에서 삭제함.
      success_ids.each do |success_id|
        i = registration_ids.index(success_id)
        registration_ids.delete_at(i)
      end
      
      
      #잘못된 registration_id 배열에서 삭제
      del_event_registrations = EventUserRegistrations.where(registration_id: delete_ids)
      del_event_registrations.destroy_all
      
      #잘못된 registration_id DB에서 삭제
      delete_ids.each do |del_id|
        i = registration_ids.index(del_id)
        registration_ids.delete_at(i)
      end
      
      #변경된 registration_id 배열/DB에서 업데이트
      update_ids.each do |up_id|
        i = registration_ids.index(up_id[:old])
        registration_ids[i] = up_id[:new]
        up_event_registrations = EventUserRegistrations.find_by_registration_id(up_id[:old])
        up_event_registrations.update(registration_id: up_id[:new])
      end
      unless registration_ids.blank?
        response, registration_ids = self.re_send_push_button(registration_ids)
        loop_flg = false if JSON.parse(response[:body])["failure"] == 0
      else
        loop_flg = false
      end
      
    end  
  end
  
  def self.re_send_push_button(registration_ids)
    gcm = GCM.new("AIzaSyD_3jJfuO8NT8G-kDHcmTiwl3w0W1JuxXQ")
    event_user_id = EventMailingList.find_by_email("shimtong1004@gmail.com").id
    registration_ids = EventUserRegistrations.where(event_user_id: event_user_id).pluck(:registration_id)
    option = { :data => { 'message' => "뽐뿌에 이벤트가 올라왔습니다." } }
    unless registration_ids.blank?
      response = gcm.send(registration_ids, option)
      return response, registration_ids
    end
  end
  
end
