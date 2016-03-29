#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

# while true
  # p "start"
begin
  head_url = "http://www.ppomppu.co.kr/zboard/"
  url = "http://www.ppomppu.co.kr/zboard/zboard.php?id=ppomppu"
  # html_str = open(url).read
  html_str = open(url, "r:UTF-8").read
  
  doc = Nokogiri::HTML(html_str)
  items = doc.css("#revolution_main_table .list0")
  
  items.each do |item|
    begin
      category_id = 1
      item_id = item.css("td")[3].css("td")[1].css("a").attr("href").value.split("=")[-1]
        
      search_ret = Ppomppu.where(category_id: category_id, item_id: item_id)
      next unless search_ret.blank?
        
      begin
        title = item.css("td")[3].css("td")[1].css("a").text.encode("utf-8", "euc-kr")
      rescue
        title = "?????"
      end
      link_url = head_url + item.css("td")[3].css("td")[1].css("a").attr("href").value
      Ppomppu.create(category_id: category_id, item_id: item_id, title: title, url: link_url)
    rescue
    end
  end
  
  items = doc.css("#revolution_main_table .list1")
  items.each do |item|
    begin
      category_id = 1
      item_id = item.css("td")[3].css("td")[1].css("a").attr("href").value.split("=")[-1]
        
      search_ret = Ppomppu.where(category_id: category_id, item_id: item_id)
      next unless search_ret.blank?
        
      begin
        title = item.css("td")[3].css("td")[1].css("a").text.encode("utf-8", "euc-kr")
      rescue
        title = "?????"
      end
      link_url = head_url + item.css("td")[3].css("td")[1].css("a").attr("href").value
      Ppomppu.create(category_id: category_id, item_id: item_id, title: title, url: link_url)
    rescue
    end
  end
rescue => e
  p e.backtrace
end
# p "end"
# end