#encoding: utf-8
class DealItem < ActiveRecord::Base
  @@isFirst = true
  
  has_many :deal_search_results
  belongs_to :deal_search_word
  
  def self.add_wemakeprice(browser)
    #위메프
    begin
      search_key = DealSearchWord.where(is_on: true)
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
          browser.span(:id =>'search_keyword_btn').click
          (1..50).each do |num|
            browser.execute_script("window.scrollBy(0,1000)")
          end
          
          doc = Nokogiri::HTML.parse(browser.html)
          unless doc.css(".search_result_tit").text.include?("없습니다.")
            
            lis = doc.css(".section_list").css("li")
            lis.each do |li|
              item_id = li.attr("deal_id")
              site_id = 1001
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
                
                # ActiveRecord::Base.transaction do
                deal_item = DealItem.create(deal_search_word_id: key.id, item_id: item_id, site_id: site_id, deal_url: deal_url, deal_image: deal_image, deal_description: deal_description, deal_start: deal_start, 
                                    deal_title: deal_title, deal_price: deal_price, deal_count: deal_count, card_interest_description: card_interest_description, deliver_charge_description: deliver_charge_description)
                # end
                search_result = DealSearchResult.where(deal_item_id: deal_item.id, deal_search_word: key.word)
                DealSearchResult.create(deal_item_id: deal_item.id, deal_search_word: key.word) if search_result.blank?
              else
                search_result = DealSearchResult.where(deal_item_id: deal_item[0].id, deal_search_word: key.word)
                DealSearchResult.create(deal_item_id: deal_item[0].id, deal_search_word: key.word) if search_result.blank?  
              end
            end
          end
        end
        return true
      rescue => e
        p e.backtrace
        return false
      end
    
  end
  
  def self.add_coupang(browser)
    begin
      search_key = DealSearchWord.where(is_on: true)
      url = "http://www.coupang.com"
      site_id = 1002
      browser.goto url
      # browser.link(:onclick=>"close_regpop();").click
      search_key.each do |key|
        p "쿠팡 데이터 수집중 #{key.word}"
        browser.text_field(:id => 'headerSearchKeyword').set key.word
        browser.a(:id => "headerSearchBtn").click
        # begin
            # browser.a(:text => "최신순").click
        # rescue
          # next
        # end
        
        
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
              
              # ActiveRecord::Base.transaction do
              deal_item = DealItem.create(deal_search_word_id: key.id, item_id: item_id, site_id: site_id, deal_url: deal_url, deal_image: deal_image, deal_description: deal_description, deal_start: deal_start,
                                    deal_title: deal_title, deal_price: deal_price, deal_count: deal_count, card_interest_description: card_interest_description, deliver_charge_description: deliver_charge_description)
              # end
              search_result = DealSearchResult.where(deal_item_id: deal_item.id, deal_search_word: key.word)
              DealSearchResult.create(deal_item_id: deal_item.id, deal_search_word: key.word) if search_result.blank?
            else
              search_result = DealSearchResult.where(deal_item_id: deal_item[0].id, deal_search_word: key.word)
              DealSearchResult.create(deal_item_id: deal_item[0].id, deal_search_word: key.word) if search_result.blank?  
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
      search_key = DealSearchWord.where(is_on: true)
      url = "http://www.g9.co.kr"
      site_id = 1003
      browser.goto url
      
      #플레쉬딜
      doc = Nokogiri::HTML.parse(browser.html)
      unless doc.css("#flash_deal_goods_list").blank?
        deal_title = doc.css("#flash_deal_goods_list").css(".title").text.delete!("\n").delete!("\t")
        deal_price = doc.css("#flash_deal_goods_list").css(".price_info").css(".price").css("strong").text
        deal_price = deal_price.scan(/\d/).join('').to_i
        deal_original_price = doc.css("#flash_deal_goods_list").css(".price_info").css(".price").css("del").text
        discount = doc.css("#flash_deal_goods_list").css(".price_info").css(".sale").text
        if doc.css("#flash_deal_goods_list").css(".tag")[0].attributes["href"] 
          rear_link_url = doc.css("#flash_deal_goods_list").css(".tag")[0].attributes["href"].value
          tmp_ary = rear_link_url.split("/")
          item_id = tmp_ary[-1]
          deal_url = url + rear_link_url
          event = Event.where(event_id: item_id, event_site_id: site_id)
          # deal_image = doc.css("#flash_deal_goods_list").css(".thumbnail")[0].attributes["src"].value
          deal_image = "http://image.g9.co.kr/g/" + item_id.to_s + "/o"
          if event.blank?
            DealItem.create(item_id: item_id, site_id: site_id, deal_url: deal_url, deal_image: deal_image, discount: discount, deal_original_price: deal_original_price,
                                  deal_title: deal_title, deal_price: deal_price)
                                  
            Event.create(event_id: item_id, event_name: deal_title, event_url: deal_url, event_site_id: site_id, image_url: deal_image, price: deal_price, original_price: deal_original_price, 
                            discount: discount, show_flg: true, push_flg: true, update_flg: true)
                                  
          end
        end
      end
      
      #영화 예메권
      browser.text_field(:id => 'txtSearchKeyword').set "영화관람권"
      browser.input(:id => "btnSearchKeyword").click
      (1..50).each{|num|
        # browser.span(:class => 'thumbs').img.wait_until_present
        browser.execute_script("window.scrollBy(0,1000)")
        # sleep 1
      }
      doc = Nokogiri::HTML.parse(browser.html)
      g9_item_list = doc.css("#searchItemList").css("li")
      g9_item_list.each do |item|
        item_id = item.css(".tag").attr("href").value.split("/")[-1].to_i
        deal_item = DealItem.where(item_id: item_id, site_id: site_id)
          
        if deal_item.blank?
          deal_url = url + item.css(".tag").attr("href").value
          # deal_image = item.css("#img#{item_id}").attr("src").value
          deal_image = "http://image.g9.co.kr/g/" + item_id.to_s + "/o"
            
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
          deal_count = item.css(".count_item").css("strong").text
            
          card_interest_description = ""
          deliver_charge_description = item.css(".ico_tag4").text
            
          deal_start = Date.today if item.css(".ico_tag2").text != ""
            
          # ActiveRecord::Base.transaction do
          deal_item = DealItem.create(deal_search_word_id: 10001, item_id: item_id, site_id: site_id, deal_url: deal_url, deal_image: deal_image, deal_description: deal_description, 
                                like_count: like_count, discount: discount, deal_original_price: deal_original_price, deal_start: deal_start, special_price: special_price,
                                deal_title: deal_title, deal_price: deal_price, deal_count: deal_count, card_interest_description: card_interest_description, deliver_charge_description: deliver_charge_description)
          # end
          unless deal_title.include?("지류")
            Event.create(event_id: item_id, event_name: deal_title, event_url: deal_url, event_site_id: site_id, image_url: deal_image, price: deal_price, original_price: deal_original_price, 
                          discount: discount, show_flg: true, push_flg: false, update_flg: true, deal_search_word_id: 10001)
          end
        end
      end
        
      #커피
      urls = [
              "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/1",#스타벅스 
              "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/538",#커피빈 
              "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/3",#공차
              "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/7410", #이디야
              "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/5", #엔젤
              "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/6", #투썸
              "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/7", #폴바셋
              "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/8", #파스구찌
              "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/9", #할리스
              "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/4", #베네
              "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/658" #오설록 
            ]
      cafe_names = ["스타벅스","커피빈","공차","이디야","엔젤리너스","투썸","폴바셋","파스구찌","할리스","카페베네","오설록"]
      urls.each_with_index do |url, url_i|
        browser.goto url
        sleep 1
        doc = Nokogiri::HTML.parse(browser.html)
        pages = doc.css(".page_btnbx").css(".ng-binding.ng-scope")
        
        pages.each_with_index do |page, i|
          browser.span(:text => "#{i+1}").click
          doc = Nokogiri::HTML.parse(browser.html)
          g9_item_list = doc.css(".lst_ecpn3").css("li")
          g9_item_list.each do |item|
            # item_id = item.css(".img_box").css("img").attr("src").value.split("/g/")[1].split('/')[0]
            item_id = item.css(".img_box").css("img")[0].attributes["data-original"].value.split("/")[-2]
            deal_item = DealItem.where(item_id: item_id, site_id: site_id)
              
            if deal_item.blank?
              deal_url = "http://www.g9.co.kr/Display/VIP/Index/" + item_id.to_s
              deal_image = "http://image.g9.co.kr/g/" + item_id.to_s + "/o"
                
              # deal_description = item.css(".tag").css(".title").css("em").text
              deal_title = "[" + cafe_names[url_i] + "] " +  item.css(".tit.ng-binding").text
              deal_price = item.css(".price.ng-binding").text.scan(/\d/).join('').to_i
              
              deal_original_price = item.css(".per_price.ng-binding.ng-scope").text.scan(/\d/).join('').to_i
              deal_original_price = "" if deal_original_price == 0
              
              special_price = item.css(".txt.ng-scope").text
              
              discount = item.css(".per.ng-binding.ng-scope").text.scan(/\d/).join('').to_i
              discount = "" if discount == 0
                
              # like_count = item.css("#fcnt#{item_id}").text.scan(/\d/).join('').to_i
              # deal_count = item.css(".count_item").css("strong").text
                
              # card_interest_description = ""
              # deliver_charge_description = item.css(".ico_tag4").text
                
              # deal_start = Date.today if item.css(".ico_tag2").text != ""
                
              # ActiveRecord::Base.transaction do
              deal_item = DealItem.create(deal_search_word_id: 10002, item_id: item_id, site_id: site_id, deal_url: deal_url, deal_image: deal_image, 
                                    discount: discount, deal_original_price: deal_original_price, special_price: special_price,
                                    deal_title: deal_title, deal_price: deal_price)
              
              Event.create(event_id: item_id, event_name: deal_title, event_url: deal_url, event_site_id: site_id, image_url: deal_image, price: deal_price, original_price: deal_original_price, 
                              discount: discount, show_flg: true, update_flg: true, deal_search_word_id: 10002, item_type_code: url_i)
              # end
            end
          end            
        end
      end
      
      url = "http://www.g9.co.kr"
      browser.goto url
      browser.goto url
      # browser.link(:onclick=>"close_regpop();").click
      search_key.each do |key|
        p "지구 데이터 수집중 #{key.word}"
        browser.text_field(:id => 'txtSearchKeyword').set key.word
        browser.input(:id => "btnSearchKeyword").click
        browser.a(:text => "최신순").click
        
        (1..50).each{|num|
          # browser.span(:class => 'thumbs').img.wait_until_present
          browser.execute_script("window.scrollBy(0,1000)")
          # sleep 1
        }
        
        doc = Nokogiri::HTML.parse(browser.html)
        g9_item_list = doc.css("#searchItemList").css("li")
        g9_item_list.each do |item|
          item_id = item.css(".tag").attr("href").value.split("/")[-1].to_i
          deal_item = DealItem.where(item_id: item_id, site_id: site_id)
          
          if deal_item.blank?
            deal_url = url + item.css(".tag").attr("href").value
            # deal_image = item.css("#img#{item_id}").attr("src").value
            deal_image = "http://image.g9.co.kr/g/" + item_id.to_s + "/o"
            
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
            deal_count = item.css(".count_item").css("strong").text
            
            card_interest_description = ""
            deliver_charge_description = item.css(".ico_tag4").text
            
            deal_start = Date.today if item.css(".ico_tag2").text != ""
            
            # ActiveRecord::Base.transaction do
            deal_item = DealItem.create(deal_search_word_id: key.id, item_id: item_id, site_id: site_id, deal_url: deal_url, deal_image: deal_image, deal_description: deal_description, 
                                  like_count: like_count, discount: discount, deal_original_price: deal_original_price, deal_start: deal_start, special_price: special_price,
                                  deal_title: deal_title, deal_price: deal_price, deal_count: deal_count, card_interest_description: card_interest_description, deliver_charge_description: deliver_charge_description)
            # end
            search_result = DealSearchResult.where(deal_item_id: deal_item.id, deal_search_word: key.word)
            DealSearchResult.create(deal_item_id: deal_item.id, deal_search_word: key.word) if search_result.blank?
          else
            search_result = DealSearchResult.where(deal_item_id: deal_item[0].id, deal_search_word: key.word)
            DealSearchResult.create(deal_item_id: deal_item[0].id, deal_search_word: key.word) if search_result.blank?  
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
      search_key = DealSearchWord.where(is_on: true)
      url = "http://deal.11st.co.kr"
      site_id = 1004
      browser.goto url
      # browser.link(:onclick=>"close_regpop();").click
      search_key.each do |key|
        p "쇼킹딜 데이터 수집중 #{key.word}"
        browser.text_field(:id => 'tSearch').set key.word
        browser.button(:onclick=>"ShockingDeal.common.goSearch('tSearch');doCommonStat('DEA0102');return false;").click
#       커서 문제로 두번 검색
        browser.text_field(:id => 'tSearch').set key.word
        browser.button(:onclick=>"ShockingDeal.common.goSearch('tSearch');doCommonStat('DEA0102');return false;").click
        # begin
          # browser.a(:text => "신규오픈").click
        # rescue
          # next
        # end
        
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
              
              # ActiveRecord::Base.transaction do
              deal_item = DealItem.create(deal_search_word_id: key.id, item_id: item_id, site_id: site_id, deal_url: deal_url, deal_image: deal_image, deal_description: deal_description, 
                                    like_count: like_count, discount: discount, deal_original_price: deal_original_price, deal_start: deal_start, special_price: special_price,
                                    deal_title: deal_title, deal_price: deal_price, deal_count: deal_count, card_interest_description: card_interest_description, deliver_charge_description: deliver_charge_description)
            
              # end
              search_result = DealSearchResult.where(deal_item_id: deal_item.id, deal_search_word: key.word)
              DealSearchResult.create(deal_item_id: deal_item.id, deal_search_word: key.word) if search_result.blank?
            else
              search_result = DealSearchResult.where(deal_item_id: deal_item[0].id, deal_search_word: key.word)
              DealSearchResult.create(deal_item_id: deal_item[0].id, deal_search_word: key.word) if search_result.blank?  
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
      search_key = DealSearchWord.where(is_on: true)
      url = "http://www.ticketmonster.co.kr"
      site_id = 1005
      browser.goto url
      begin
      rescue
        browser.link(:onclick=>"hideSubscribe();return false;").click
      end
      search_key.each do |key|
        p "티몬 데이터 수집중 #{key.word}"
        if @@isFirst
          browser.text_field(:id => 'search_keyword').set key.word
          browser.a(:id => "search_submit").click
          @@isFirst = false
        else
          browser.text_field(:id => 'top_srch').set key.word
          browser.button(:class => "btn_search").click
        end
        
        # begin
          # browser.a(:text => "최신순").click
        # rescue
          # next
        # end
        
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
            is_closed = true if item.css(".deal_item_thumb_info").css(".soldout").text != ""
            
            unless is_closed && item.css(".deal_item_sticker_top").css("img").blank?
              is_closed  = true if !item.css(".deal_item_sticker_top").css("img").blank? && item.css(".deal_item_sticker_top").css("img").attr("alt").value.include?("매진")
            end
            
            
            
            # ActiveRecord::Base.transaction do
            deal_item = DealItem.create(deal_search_word_id: key.id, item_id: item_id, site_id: site_id, deal_url: deal_url, deal_image: deal_image, deal_description: deal_description, is_closed: is_closed, 
                                  discount: discount, deal_original_price: deal_original_price, deal_start: deal_start,
                                  deal_title: deal_title, deal_price: deal_price, deal_count: deal_count, card_interest_description: card_interest_description, deliver_charge_description: deliver_charge_description)
              
            # end
            search_result = DealSearchResult.where(deal_item_id: deal_item.id, deal_search_word: key.word)
            DealSearchResult.create(deal_item_id: deal_item.id, deal_search_word: key.word) if search_result.blank?
          else
            search_result = DealSearchResult.where(deal_item_id: deal_item[0].id, deal_search_word: key.word)
            DealSearchResult.create(deal_item_id: deal_item[0].id, deal_search_word: key.word) if search_result.blank?  
          end          
        end
      end
      return true
    rescue
      return false
    end
    
  end
  
  def self.add_action(browser)
    begin
      site_id = 1006
      url = "http://listings.auction.co.kr/category/List.aspx?category=86030100"
      browser.goto url
      browser.div(:id => "ucAttributeIndexBox1_rAttributeSet_hdivMoreView_0").click #더보기
            
      click_ids = [ 
                    "chkElement__ctl0_-1_19721", #스타벅스0
                    "chkElement__ctl0_-1_498284", #베네9
                    "chkElement__ctl0_-1_19728", #투썸5
                    "chkElement__ctl0_-1_896045", #파스구찌7
                    "chkElement__ctl0_-1_19725", #엔젤4
                    "chkElement__ctl0_-1_19723", #할리스8
                    "chkElement__ctl0_-1_23703", #오설록10
                    "chkElement__ctl0_-1_19729", #커피빈1
                    "chkElement__ctl0_-1_1647224", #폴바셋6
                    "chkElement__ctl0_-1_1647247", #공차2
                    "" #3
                  ]
      item_type_codes = [0, 9, 5, 7, 4, 8, 10, 1, 6, 2, 3]
      cafe_names = ["스타벅스","커피빈","공차","이디야","엔젤리너스","투썸","폴바셋","파스구찌","할리스","카페베네","오설록"]
      click_ids.each_with_index do |click_id, index|
        if index == 0
          browser.checkbox(:id => "chkElement_ucAttributeIndexBox1_-1_19721").click #스타벅스
        elsif index == 9
          url = "http://through.auction.co.kr/common/SafeRedirect.aspx?cc=0FA0&LPFwc=86030100&next=http://listings.auction.co.kr/category/List.aspx?category=86030300"
          browser.goto url
          browser.checkbox(:id => "chkElement_ucAttributeIndexBox1_-1_1647247").click #공차
        elsif index == 10
          browser.text_field(:id => 'keywordRetry').set "이디야"
          browser.input(:class => 'btn_cg_sc').click
        else
          browser.checkbox(:id => "#{click_id}").click
        end
        while 1
          doc = Nokogiri::HTML.parse(browser.html)
          if doc.css("#ucPager_dListMoreView").blank?
            browser.scroll.to :bottom
            break
          else
            begin
              btn = browser.div(:id => "ucPager_dListMoreView")
              browser.scroll.to btn
              browser.execute_script("window.scrollBy(0,-200)")
              browser.div(:id => 'ucPager_dListMoreView').click
            rescue
              break
            end
          end
        end
        doc = Nokogiri::HTML.parse(browser.html)
        
        list = doc.css("#ucItemList_listview .list_view")
        list.each do |item|
          item_id = item.attr("id").split("_")[1]
          deal_item = DealItem.where(item_id: item_id, site_id: site_id)
              
          if deal_item.blank?
            deal_url = "http://itempage3.auction.co.kr/DetailView.aspx?ItemNo=" + item_id.to_s
            deal_image = item.css(".image img").attr("data-original").value
                  
            # deal_description = item.css(".tag").css(".title").css("em").text
            deal_title = item.css(".item_title a").text.delete!("\n").delete!("\t")
            deal_price = item.css(".item_price").text.scan(/\d/).join('').to_i
               
            deal_original_price = item.css(".list_price").text.scan(/\d/).join('').to_i
            deal_original_price = "" if deal_original_price == 0
               
            special_price = ""
                
            discount = item.css(".you_save strong").text.scan(/\d/).join('').to_i
            discount = "" if discount == 0
            if item.css(".feedback strong").size == 3
              deal_count = item.css(".feedback strong")[1].text.scan(/\d/).join('').to_i
            else
              deal_count = nil
            end 
            deal_item = DealItem.create(deal_search_word_id: 10002, item_id: item_id, site_id: site_id, deal_url: deal_url, deal_image: deal_image, 
                                    discount: discount, deal_original_price: deal_original_price, special_price: special_price,
                                    deal_title: deal_title, deal_price: deal_price)
                
            Event.create(event_id: item_id, event_name: deal_title, event_url: deal_url, event_site_id: site_id, image_url: deal_image, price: deal_price, original_price: deal_original_price, 
                              discount: discount, show_flg: true, update_flg: true, deal_search_word_id: 10002, item_type_code: item_type_codes[index])
          end
        end
        if index != 10
          browser.scroll.to :top
          browser.checkbox(:id => "#{click_id}").click #클릭 해제
          sleep 1
        end
      end  
    rescue => e
      p e.backtrace
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
