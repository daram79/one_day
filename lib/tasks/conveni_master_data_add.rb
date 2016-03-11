#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

conveni_items = ConvenienceItem.where(item_type: "1+1")

conveni_items.each do |c|
  flg = ConvenienceMaster.find_by_item_name(c.name)
  ConvenienceMaster.create(item_name: c.name) unless flg
end
