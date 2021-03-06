#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

# while true
  # p "start"
begin
  head_url = "http://www.ppomppu.co.kr/zboard/"
  #자게
  urls = [
    "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=30&category=&search_type=sub_memo&keyword=%C0%CC%BA%A5%C6%AE&x=0&y=0", #이벤트
    "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=20&category=&search_type=sub_memo&keyword=%C6%BC%B8%F3&x=0&y=0", #티몬
    "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=20&category=&search_type=sub_memo&keyword=%C4%ED%C6%CE&x=0&y=0" #쿠팡
    ]
    
  urls.each do |url|
    html_str = open(url).read
  doc = Nokogiri::HTML(html_str)
  items = doc.css("#revolution_main_table tr")
    items.each do |item|
      begin
        next unless item.attr("class")
        category_id = 2
        item_id = item.css("td")[2].css("a").attr("href").value.split("=")[-1]
        search_ret = Ppomppu.where(category_id: category_id, item_id: item_id)
        next unless search_ret.blank?
        
        
        title = item.css("td")[2].css("a").text
        link_url = head_url + item.css("td")[2].css("a").attr("href").value
        Ppomppu.create(category_id: category_id, item_id: item_id, title: title, url: link_url)
      rescue
      end
    end
  end
rescue => e
  pp e.backtrace
end
# p "end"
# end