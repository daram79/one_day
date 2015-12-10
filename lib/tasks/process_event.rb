#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

keys = DealSearchResult.all.group("deal_search_word").pluck(:deal_search_word)

keys.each do |key|
  datas = DealSearchResult.joins(:deal_item).where(deal_search_word: key).where("deal_items.deal_count > 1000")

  datas.each do |data|
    event = Event.where(event_id: data.deal_item.item_id, event_site_id: data.deal_item.site_id)
    Event.create(event_id: data.deal_item.item_id, event_name: data.deal_item.deal_title, event_url: data.deal_item.deal_url,
                  price: data.deal_item.deal_price, original_price: data.deal_item.deal_original_price, discount: data.deal_item.discount,  
                  image_url: data.deal_item.deal_image, event_site_id: data.deal_item.site_id, show_flg: true) if event.blank?
                                                                                                                              
  end
end
  