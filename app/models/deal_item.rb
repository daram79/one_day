#encoding: utf-8
class DealItem < ActiveRecord::Base
  
  def self.add_wemakeprice(browser)
    #위메프
    begin
      search_key = DealSearchWord.all
      url = "http://www.wemakeprice.com"
        # headless = Headless.new
        # headless.start
        browser.goto url
        begin
          browser.link(:onclick=>"close_regpop();").click
        rescue
        end
        search_key.each do |key|
          p "위메프 데이터 수집중 #{key.word}"
          browser.text_field(:id => 'searchKeyword').set key.word
          browser.span(:onclick=>"$('#top_search_form').submit();").click
          begin
            browser.a(:href=>"javascript:dealsort('#{key.word}','open');").click
          rescue
            next
          end
          (1..50).each{|num|
            browser.execute_script("window.scrollBy(0,1000)")
          }
          doc = Nokogiri::HTML.parse(browser.html)
          unless doc.css(".search_result_tit").text.include?("없습니다.")
            
            lis = doc.css(".section_list").css("li")
            lis.each do |li|
              item_id = li.attr("deal_id")
              site_id = 1
              deal_item = DealItem.where(item_id: item_id, site_id: site_id)
              if deal_item.blank?
                deal_url = url + li.css(".link").css(".type03").css("a").attr("href").value
                deal_image = li.css("span").css(".box_thumb").css(".lazy").attr("src").value
                deal_description = li.css(".link").css(".type03").css("a").css(".box_desc").css(".standardinfo").text
                deal_title = li.css(".link").css(".type03").css("a").css(".box_desc").css(".tit_desc").text
                deal_price = li.css(".link").css(".type03").css("a").css(".box_desc").css(".txt_info").css(".sale").text.scan(/\d/).join('').to_i
                deal_count = li.css(".link").css(".type03").css("a").css(".box_desc").css(".point").text.scan(/\d/).join('').to_i
                #이자
                card_interest_description = li.css(".link").css(".type03").css(".bl").text
                #배송
                deliver_charge_description = li.css(".link").css(".type03").css(".gr").text
                
                deal_start = Date.today if li.css(".link").css(".type03").css(".box_sticker").css(".ico_comm").text == "오늘오픈"
                
                ActiveRecord::Base.transaction do
                  DealItem.create!(deal_search_word_id: key.id, item_id: item_id, site_id: site_id, deal_url: deal_url, deal_image: deal_image, deal_description: deal_description, deal_start: deal_start, 
                                    deal_title: deal_title, deal_price: deal_price, deal_count: deal_count, card_interest_description: card_interest_description, deliver_charge_description: deliver_charge_description)
                end
              end
            end
          end
        end
        return true
      rescue
        return false
      end
    
  end
  
  def self.add_coupang(browser)
    begin
      search_key = DealSearchWord.all
      url = "http://www.coupang.com"
      site_id = 2
      browser.goto url
      # browser.link(:onclick=>"close_regpop();").click
      search_key.each do |key|
        p "쿠팡 데이터 수집중 #{key.word}"
        browser.text_field(:id => 'headerSearchKeyword').set key.word
        browser.a(:id => "headerSearchBtn").click
        begin
            browser.a(:text => "최신순").click
        rescue
          next
        end
        
        
        doc = Nokogiri::HTML.parse(browser.html)
        unless doc.css("#productList").blank?
          product_info = doc.css("#productList").attr("data-products").value
          hash_product_info = JSON.parse product_info
          page_size = hash_product_info["productSizePerPage"]
          
          ids = hash_product_info["indexes"]
          ids.each do |id|
            item_id = id
            deal_item = DealItem.where(item_id: item_id, site_id: site_id)
            if deal_item.blank?
              li = doc.css("##{id}")
              deal_url = url + li.css(".detail-link").attr("href").value
              deal_image = li.css(".detail-link").css("img").attr("src").value
              deal_description = ""
              deal_title = li.css(".detail-link").css(".title").css("em").text
              deal_price = li.css(".detail-link").css(".price").css("em").text.scan(/\d/).join('').to_i
              deal_count = li.css(".detail-link").css(".condition").css("em")[1].text if li.css(".detail-link").css(".condition").css("em").size > 1
              
              card_interest_description = ""
              deliver_charge_description = li.css(".delivery-9800").text
              deliver_charge_description = li.css(".delivery-free").text if deliver_charge_description == ""
              
              deal_start = Date.today if li.css(".today-open").text != ""
              
              ActiveRecord::Base.transaction do
                DealItem.create!(deal_search_word_id: key.id, item_id: item_id, site_id: site_id, deal_url: deal_url, deal_image: deal_image, deal_description: deal_description, deal_start: deal_start,
                                    deal_title: deal_title, deal_price: deal_price, deal_count: deal_count, card_interest_description: card_interest_description, deliver_charge_description: deliver_charge_description)
              end
            end
          end
        end
      end
      return true
    rescue
      return false
    end
    
  end
  
  
  def self.add_g9(browser)
    begin
      search_key = DealSearchWord.all
      url = "http://www.g9.co.kr"
      site_id = 3
      browser.goto url
      
      #플레쉬딜
      doc = Nokogiri::HTML.parse(browser.html)
      unless doc.css("#flash_deal_goods_list").blank?
        deal_title = doc.css("#flash_deal_goods_list").css(".title").text.delete!("\n").delete!("\t")
        deal_price = doc.css("#flash_deal_goods_list").css(".price_info").css(".price").css("strong").text
        deal_original_price = doc.css("#flash_deal_goods_list").css(".price_info").css(".price").css("del").text
        discount = doc.css("#flash_deal_goods_list").css(".price_info").css(".sale").text
        if doc.css("#flash_deal_goods_list").css(".tag")[0].attributes["href"] 
          rear_link_url = doc.css("#flash_deal_goods_list").css(".tag")[0].attributes["href"].value
          tmp_ary = rear_link_url.split("/")
          item_id = tmp_ary[-1]
          deal_url = url + rear_link_url
          event = Event.where(event_id: event_id, event_site_id: event_site_id)
          deal_image = doc.css("#flash_deal_goods_list").css(".thumbnail")[0].attributes["src"].value
          if event.blank?
            DealItem.create!(item_id: item_id, site_id: site_id, deal_url: deal_url, deal_image: deal_image, discount: discount, deal_original_price: deal_original_price,
                                  deal_title: deal_title, deal_price: deal_price)
                                  
          end
        end
      end
      
      
      # browser.link(:onclick=>"close_regpop();").click
      search_key.each do |key|
        p "지구 데이터 수집중 #{key.word}"
        browser.text_field(:id => 'txtSearchKeyword').set key.word
        browser.input(:id => "btnSearchKeyword").click
        browser.a(:text => "최신순").click
        
        (1..50).each{|num|
          browser.execute_script("window.scrollBy(0,1000)")
        }
        
        doc = Nokogiri::HTML.parse(browser.html)
        g9_item_list = doc.css("#searchItemList").css("li")
        g9_item_list.each do |item|
          item_id = item.css(".tag").attr("href").value.split("/")[-1].to_i
          deal_item = DealItem.where(item_id: item_id, site_id: site_id)
          if deal_item.blank?
            deal_url = url + item.css(".tag").attr("href").value
            deal_image = item.css("#img#{item_id}").attr("src").value
            
            deal_description = item.css(".tag").css(".title").css("em").text
            begin
              deal_title = item.css(".tag").css(".title").text.delete!("\t").delete!("\n").delete(deal_description)
            rescue
              title = item.css(".tag").css(".title").to_s
              title_s_index = title.index("</em>") + 5
              title_e_index = title.size
              deal_title = title[title_s_index..title_e_index].delete!("\t").delete!("\n").delete("</span>")
            end
            deal_price = item.css(".price_info").css(".price").css("strong").text.scan(/\d/).join('').to_i
            deal_original_price = item.css(".price_info").css(".price").css("del").text.scan(/\d/).join('').to_i
            special_price = item.css(".price_info").css(".price").css("em").text
            discount = item.css(".price_info").css(".sale").text.scan(/\d/).join('').to_i
            
            like_count = item.css("#fcnt#{item_id}").text.scan(/\d/).join('').to_i
            deal_count = deal_price = item.css(".count_item").css("strong").text
            
            card_interest_description = ""
            deliver_charge_description = item.css(".ico_tag4").text
            
            deal_start = Date.today if item.css(".ico_tag2").text != ""
            
            ActiveRecord::Base.transaction do
              DealItem.create!(deal_search_word_id: key.id, item_id: item_id, site_id: site_id, deal_url: deal_url, deal_image: deal_image, deal_description: deal_description, 
                                  like_count: like_count, discount: discount, deal_original_price: deal_original_price, deal_start: deal_start, special_price: special_price,
                                  deal_title: deal_title, deal_price: deal_price, deal_count: deal_count, card_interest_description: card_interest_description, deliver_charge_description: deliver_charge_description)
            end
          else
                
          end
          
        end
      end
      return true
    rescue
      return false
    end
    
  end
  
  #쇼킹딜
  def self.add_shocking_deal(browser)
    begin
      search_key = DealSearchWord.all
      url = "http://deal.11st.co.kr"
      site_id = 4
      browser.goto url
      # browser.link(:onclick=>"close_regpop();").click
      search_key.each do |key|
        p "쇼킹딜 데이터 수집중 #{key.word}"
        browser.text_field(:id => 'tSearch').set key.word
        browser.button(:onclick=>"ShockingDeal.common.goSearch('tSearch');doCommonStat('DEA0102');return false;").click
        begin
          browser.a(:text => "신규오픈").click
        rescue
          next
        end
        
        (1..50).each{|num|
          browser.execute_script("window.scrollBy(0,1000)")
        }
        
        doc = Nokogiri::HTML.parse(browser.html)
        item_list = doc.css("#prd_list").css("li")
        unless item_list.blank?
          item_list.each do |item|
            item_id = item.attr("prdno").to_i
            deal_item = DealItem.where(item_id: item_id, site_id: site_id)
            if deal_item.blank?
              deal_url = item.css("a").attr("href").value
              deal_image = item.css(".thumb_prd").css("img").attr("src").value
              
              if item.css("a").css("p").size > 1 && !(item.css("a").css("p")[1].include?("개 리뷰"))
                deal_description = item.css("a").css("p")[1].text
              end
               
              deal_title = item.css("strong")[0].text
              
              deal_price = item.css(".price_wrap").css("strong").text.scan(/\d/).join('').to_i
              deal_original_price = item.css(".price_wrap").css("s").text.scan(/\d/).join('').to_i
              deal_original_price = nil if deal_original_price == 0
              special_price = item.css(".sale").css(".special_price").text
              
              discount = item.css(".sale").text.scan(/\d/).join('').to_i if special_price == ""
              
              like_count =  item.css(".like_this").css("button").text.scan(/\d/).join('').to_i
              deal_count = item.css(".buying_desc").text.scan(/\d/).join('').to_i
              
              card_interest_description = ""
              deliver_charge_description = item.css(".ico_deliver1").text
              
              deal_start = Date.today if item.css(".ico_today_open").text != ""
              
              ActiveRecord::Base.transaction do
                DealItem.create!(deal_search_word_id: key.id, item_id: item_id, site_id: site_id, deal_url: deal_url, deal_image: deal_image, deal_description: deal_description, 
                                    like_count: like_count, discount: discount, deal_original_price: deal_original_price, deal_start: deal_start, special_price: special_price,
                                    deal_title: deal_title, deal_price: deal_price, deal_count: deal_count, card_interest_description: card_interest_description, deliver_charge_description: deliver_charge_description)
              end
            else
                  
            end
            
          end
        end
      end
      return true
    rescue
      return false
    end
    
  end
  
  #티몬
  def self.add_tmon(browser)
    begin
      search_key = DealSearchWord.all
      url = "http://www.ticketmonster.co.kr"
      site_id = 5
      browser.goto url
      browser.link(:onclick=>"hideSubscribe();return false;").click
      isFirst = true
      search_key.each do |key|
        p "티몬 데이터 수집중 #{key.word}"
        if isFirst
          browser.text_field(:id => 'search_keyword').set key.word
          browser.a(:id => "search_submit").click
          isFirst = false
        else
          browser.text_field(:id => 'top_srch').set key.word
          browser.button(:class => "btn_search").click
        end
        
        begin
          browser.a(:text => "최신순").click
        rescue
          next
        end
        
        (1..50).each{|num|
          browser.execute_script("window.scrollBy(0,1000)")
        }
        doc = Nokogiri::HTML.parse(browser.html)
        item_list = doc.css("#_resultDeals").css("li")
        item_list.each do |item|
          item_id = item.css(".deal_item_anchor").attr("href").value.split("?")[0].split("/")[-1].to_i
          if item_id == 0
            item_id = item.css(".deal_item_thumb").css("img").attr("src").value.split("_")[0].split("/")[-2].to_i
          end
          deal_item = DealItem.where(item_id: item_id, site_id: site_id)
          if deal_item.blank?
            deal_url = item.css(".deal_item_anchor").attr("href").value
            if deal_url.include?("#none")
              deal_url = "http://www.ticketmonster.co.kr/deal/#{item_id}?keyword"
            end
            deal_image = item.css(".deal_item_thumb").css("img").attr("src").value
            deal_description = item.css(".deal_item_body_top").css(".deal_item_subtitle").text
            deal_title = item.css(".deal_item_body_top").css(".deal_item_title").text.delete!("\n").delete!("\t")
            
            deal_price = item.css(".deal_item_price").css("em")[0].text.scan(/\d/).join('').to_i
            deal_original_price = item.css(".normal_price").css("em").text.scan(/\d/).join('').to_i
            deal_original_price = nil if deal_original_price == 0
            # special_price = item.css(".sale").css(".special_price").text
            
            discount = item.css(".discount_sale").css(".deal_item_discount").text.scan(/\d/).join('').to_i if item.css(".discount_sale").css(".deal_item_discount").text != ""
            
            # like_count =  item.css(".like_this").css("button").text.scan(/\d/).join('').to_i
            deal_count = item.css(".deal_item_purchase").css("em").text.scan(/\d/).join('').to_i
            
            card_interest_description = ""
            deliver_charge_description = item.css(".deal_item_sticker_bottom").css(".delivery").text
            
            deal_start = Date.today if item.css(".deal_item_sticker_bottom").css(".open_today").text != ""
            is_closed = false
            is_closed = true if item.css("deal_item_thumb_info").css(".soldout").text != ""
            
            is_closed  = true if item.css(".deal_item_sticker_top").css("img").attr("src").value == "http://img1.tmon.kr/deals/sticker/sticker_7ee62.png"
            
            
            
            ActiveRecord::Base.transaction do
              DealItem.create!(deal_search_word_id: key.id, item_id: item_id, site_id: site_id, deal_url: deal_url, deal_image: deal_image, deal_description: deal_description, is_closed: is_closed, 
                                  discount: discount, deal_original_price: deal_original_price, deal_start: deal_start,
                                  deal_title: deal_title, deal_price: deal_price, deal_count: deal_count, card_interest_description: card_interest_description, deliver_charge_description: deliver_charge_description)
            end
          else
                
          end
          
        end
      end
      return true
    rescue
      return false
    end
    
  end
  
  def self.movie_event_megabox(browser)
    begin
      url = "http://www.megabox.co.kr/?menuId=store"
      browser.goto url
      @title = "[메가박스]"
      event_site_id = 4003
      
      doc = Nokogiri::HTML.parse(browser.html)
      lis = doc.css(".store_lst").css("li")
      @event_ary = []
      lis.each do |li|
        event_id = li.css(".blank").attr("data-code").value
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        if event.blank?
          title = li.css("h5").text
          price = li.css("b")[0].text
          price.lstrip!
          original_price = li.css("s").text
          event_name = "[메가박스]" + title 
          event_url = url
          image_url = li.css(".img_pro").attr("src").value
        
          if title.include?("1+1")
            Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price, 
                            show_flg: true, push_flg: true, update_flg: true)
          else
            Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price)
          end
        end
      end
      return true
    rescue => e
      return false
    end
  end
end
