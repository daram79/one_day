#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

#deal_item데이터를 필터해서 event에 추가함.

url = "http://www.ppomppu.co.kr/hot.php?id=ppomppu"
head_url = "http://www.ppomppu.co.kr"
html_str = open(url).read
doc = Nokogiri::HTML(html_str)
items = doc.css(".board_table .line")
items.each do |item|
  begin
    item_id = item.css("a")[1].attr("href").split("=")[-1]
    search_ret = Ppomppu.where(category_id: 1, item_id: item_id)
      next unless search_ret.blank?
      category_id = 1
      title = item.css("a")[1].text
      link_url = head_url + item.css("a")[1].attr("href")
      Ppomppu.create(category_id: 1, item_id: item_id, title: title, url: link_url)
  rescue
  end
end
