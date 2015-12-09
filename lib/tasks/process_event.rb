#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

keys = DealSearchResult.all.group("deal_search_word").pluck(:deal_search_word)

keys.each do |key|
  datas = DealSearchResult.joins(:deal_item).where(deal_search_word: key).where("deal_items.deal_count > 5000")

  datas.each do |data|
    word_data = DealSearchWord.find_by_word(data.deal_search_word)
    Event.create(event_id: data.deal_item.item_id, event_name: data.deal_item.deal_title, event_url: data.deal_item.deal_url, event_site_id: word_data.id)
  end
end
  