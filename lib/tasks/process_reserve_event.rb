#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

# event_reserves = EventReserve.where(add_flg: false)
event_reserves = EventReserve.where(add_flg: false)

event_reserves.each do |event_reserve|
  if event_reserve.add_time <= Time.now
    event = Event.create(event_name: event_reserve.event_name, event_url: event_reserve.event_url, event_site_id: event_reserve.event_site_id, 
                  image_url: event_reserve.image_url, price: event_reserve.price, original_price: event_reserve.original_price, discount: event_reserve.discount, 
                  show_flg: event_reserve.show_flg, push_flg: event_reserve.push_flg, update_flg: event_reserve.update_flg, deal_search_word_id: event_reserve.deal_search_word_id)
    Event.send_push_button(event) if event_reserve.push
    event_reserve.update(add_flg: true, event_id: event.id, push: false)
  end
end


event_reserves = EventReserve.where(close_flg: false)

event_reserves.each do |event_reserve|
  if event_reserve.close_time <= Time.now
    event_reserve.event.update(show_flg: false, super_flg: false)
    event_reserve.update(close_flg: true)
  end
end