#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

# while true
  # p "start"
begin
  head_url = "http://www.ppomppu.co.kr/zboard/"
  #자게
  urls = [
    "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=20&category=&search_type=sub_memo&keyword=%B9%F6%B0%C5%C5%B7&x=0&y=0", #버거킹
    "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=20&category=&search_type=sub_memo&keyword=%B8%C6%B5%B5%B3%AF%B5%E5&x=0&y=0", #맥도날드
    "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=20&category=&search_type=sub_memo&keyword=KFC&x=0&y=0", #KFC
    "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=20&category=&search_type=sub_memo&keyword=%C7%D7%B0%F8&x=0&y=0"
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