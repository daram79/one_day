#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

head_url = "http://www.ppomppu.co.kr"
url = "http://www.ppomppu.co.kr/zboard/zboard.php?id=ppomppu"
html_str = open(url).read

doc = Nokogiri::HTML(html_str)
items = doc.css("#revolution_main_table .list0")

items.each do |item|
  begin
    category_id = 1
    item_id = item.css("td")[3].css("td")[1].css("a").attr("href").value.split("=")[-1]
      
    search_ret = Ppomppu.where(category_id: category_id, item_id: item_id)
    next unless search_ret.blank?
      
    title = item.css("td")[3].css("td")[1].css("a").text
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
      
    title = item.css("td")[3].css("td")[1].css("a").text
    link_url = head_url + item.css("td")[3].css("td")[1].css("a").attr("href").value
    Ppomppu.create(category_id: category_id, item_id: item_id, title: title, url: link_url)
  rescue
  end
end




#자게
url = "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=30&category=&search_type=sub_memo&keyword=%C0%CC%BA%A5%C6%AE&x=0&y=0"
head_url = "http://www.ppomppu.co.kr/zboard/"
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
