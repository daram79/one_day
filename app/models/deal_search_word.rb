class DealSearchWord < ActiveRecord::Base
  
  def self.add_key_wemakeprice(browser)
    url = "http://www.wemakeprice.com"
    browser.goto url
    begin
      browser.link(:onclick=>"close_regpop();").click
    rescue
    end
    
    doc = Nokogiri::HTML.parse(browser.html)
    key_list = doc.css(".list-top-searches").css("li")
    for i in 0...10
      key = key_list[i]
      search_key = key.css("a").attr("title").value
      deal_search_word = DealSearchWord.find_by_word(search_key)
      unless deal_search_word
        ActiveRecord::Base.transaction do
          DealSearchWord.create!(word: search_key)
        end
      end
    end
  end
  
  def self.add_key_coupang(browser)
    url = "http://www.coupang.com"
    browser.goto url
    
    doc = Nokogiri::HTML.parse(browser.html)
    key_list = doc.css(".search-rank-list").css("li")
    for i in 0...10
      key = key_list[i]
      search_key = key.css(".search-rank-title").text
      deal_search_word = DealSearchWord.find_by_word(search_key)
      unless deal_search_word
        ActiveRecord::Base.transaction do
          DealSearchWord.create!(word: search_key)
        end
      end
    end
  end
  
end
