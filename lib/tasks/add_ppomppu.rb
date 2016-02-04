#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

# while true
  # p "start"
begin
  head_url = "http://www.ppomppu.co.kr/zboard/"
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
  urls = ["http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=30&category=&search_type=sub_memo&keyword=%C0%CC%BA%A5%C6%AE&x=0&y=0", #이벤트
    "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=20&category=&search_type=sub_memo&keyword=%C6%BC%B8%F3&x=0&y=0", #티몬
    "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=20&category=&search_type=sub_memo&keyword=%C4%ED%C6%CE&x=0&y=0", #쿠팡
    "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=20&category=&search_type=sub_memo&keyword=G9&x=22&y=15", #G9
    "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=20&category=&search_type=sub_memo&keyword=%C1%F6%B8%B6%C4%CF&x=0&y=0", #지마켓
    "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=20&category=&search_type=sub_memo&keyword=G%B8%B6%C4%CF&x=0&y=0", #G마켓
    "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=20&category=&search_type=sub_memo&keyword=11%B9%F8%B0%A1&x=0&y=0", #11번가
    "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=20&category=&search_type=sub_memo&keyword=%BF%C1%BC%C7&x=0&y=0", #옥션
    "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=20&category=&search_type=sub_memo&keyword=%B7%D4%B5%A5%B8%B6%C6%AE&x=0&y=0",#롯데마트
    "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=20&category=&search_type=sub_memo&keyword=%C0%CC%B8%B6%C6%AE&x=0&y=0", #이마트
    "http://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page_num=20&category=&search_type=sub_memo&keyword=%C8%A8%C7%C3&x=20&y=13" #홈플
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