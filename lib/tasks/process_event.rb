#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

# keys = DealSearchResult.all.group("deal_search_word").pluck(:deal_search_word)

# keys.each do |key|
  # datas = DealSearchResult.joins(:deal_item).where(deal_search_word: key).where("deal_items.deal_count > 1000")
  
  # datas = DealSearchResult.joins(:deal_item).where(deal_search_word: key)
    deal_items = DealItem.where("deal_search_word_id is not null").where(is_closed: false)
    deal_items.each do |item|
      lo = item.deal_search_word.deal_location_and_item_types[0].deal_location_keys.pluck(:key)
      ty = item.deal_search_word.deal_location_and_item_types[1].deal_location_keys.pluck(:key)
      
      event = Event.where(event_id: item.item_id, event_site_id: item.site_id)
      if event.blank?
        discount = item.discount == nil ? "" : item.discount
        deal_original_price = item.deal_original_price  == nil ? "" : item.deal_original_price
        if ty.any? { |word| item.deal_title.include?(word) } && !(["키자니아", "뽀로로", "롯데월드앞", "롯데월드5분"].any? { |word| item.deal_title.include?(word) })
          Event.create(event_id: item.item_id, event_name: item.deal_title, event_url: item.deal_url,
                    price: item.deal_price, original_price: deal_original_price, discount: discount,  
                    image_url: item.deal_image, event_site_id: item.site_id, show_flg: true, deal_search_word_id: item.deal_search_word_id, item_type_code: 1)
        
        elsif lo.any? { |word| item.deal_title.include?(word) }
          Event.create(event_id: item.item_id, event_name: item.deal_title, event_url: item.deal_url,
                    price: item.deal_price, original_price: deal_original_price, discount: discount,  
                    image_url: item.deal_image, event_site_id: item.site_id, show_flg: true, deal_search_word_id: item.deal_search_word_id, item_type_code: 0)                    
          
        end
      end
    end
  # datas.each do |data|
    # event = Event.where(event_id: data.deal_item.item_id, event_site_id: data.deal_item.site_id)
    # Event.create(event_id: data.deal_item.item_id, event_name: data.deal_item.deal_title, event_url: data.deal_item.deal_url,
                  # price: data.deal_item.deal_price, original_price: data.deal_item.deal_original_price, discount: data.deal_item.discount,  
                  # image_url: data.deal_item.deal_image, event_site_id: data.deal_item.site_id, show_flg: true) if event.blank?
#                                                                                                                               
  # end
# end
  