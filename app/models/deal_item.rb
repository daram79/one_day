#encoding: utf-8
class DealItem < ActiveRecord::Base
  @@isFirst = true
  
  has_many :deal_search_results
  belongs_to :deal_search_word
  
  def self.wait_auction(browser)
    while 1
      doc = Nokogiri::HTML.parse(browser.html)
      break if doc.css("#sum_ajax_loading").attr("style").value.include?("display: none;")
      # doc.css("#sum_ajax_loading")
      # tmp = browser.div(:id, "sum_ajax_loading").style 'display'
      # break if tmp == "none"
    end
  end
  
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
      # unless doc.css("#flash_deal_goods_list").blank?
      unless doc.css("#flash_deal_goods_list").css(".tag").blank?
        p "G9 플레쉬딜 정보 수집"
        
        deal_title = doc.css("#flash_deal_goods_list").css(".title").text
        
        deal_title = doc.css("#flash_deal_goods_list").css(".subject").text if deal_title == "" 
        
        deal_title = deal_title.delete!("\n") if deal_title.include?("\n")
        deal_title = deal_title.delete!("\t") if deal_title.include?("\t")
        
        deal_price = doc.css("#flash_deal_goods_list").css(".price_info").css(".price").css("strong").text
        deal_price = deal_price.scan(/\d/).join('').to_i
        deal_original_price = doc.css("#flash_deal_goods_list").css(".price_info").css(".price").css("del").text
        discount = doc.css("#flash_deal_goods_list").css(".price_info").css(".sale").text
        if doc.css("#flash_deal_goods_list").css(".tag")[0].attributes["href"] 
          rear_link_url = doc.css("#flash_deal_goods_list").css(".tag")[0].attributes["href"].value
          tmp_ary = rear_link_url.split("/")
          item_id = tmp_ary[-1]
          deal_url = url + rear_link_url
          event = Event.where(event_id: item_id, event_site_id: 9002)
          # deal_image = doc.css("#flash_deal_goods_list").css(".thumbnail")[0].attributes["src"].value
          deal_image = "http://image.g9.co.kr/g/" + item_id.to_s + "/o"
          if event.blank?
            DealItem.create(item_id: item_id, site_id: 9002, deal_url: deal_url, deal_image: deal_image, discount: discount, deal_original_price: deal_original_price,
                                  deal_title: deal_title, deal_price: deal_price)
                                  
            Event.create(event_id: item_id, event_name: deal_title, event_url: deal_url, event_site_id: 9002, image_url: deal_image, price: deal_price, original_price: deal_original_price, 
                            discount: discount, show_flg: true, push_flg: true, update_flg: true)
                                  
          end
        else
          event = Event.where(event_site_id: 9002).last
          event.update(show_flg: false) if event
        end
      end
      
      #영화 예메권
      # begin
        # browser.text_field(:id => 'txtSearchKeyword').set "영화관람권"
        # browser.input(:id => "btnSearchKeyword").click
#         
        # browser.scroll.to :bottom
        # sleep 1
#         
        # doc = Nokogiri::HTML.parse(browser.html)
        # g9_item_list = doc.css("#searchItemList").css("li")
        # p "G9 영화티켓 정보 수집"
        # g9_item_list.each do |item|
          # item_id = item.css(".tag").attr("href").value.split("/")[-1].to_i
          # deal_item = DealItem.where(item_id: item_id, site_id: site_id)
#           
          # if deal_item.blank?
            # deal_url = url + item.css(".tag").attr("href").value
            # # deal_image = item.css("#img#{item_id}").attr("src").value
            # deal_image = "http://image.g9.co.kr/g/" + item_id.to_s + "/o"
#               
            # deal_description = item.css(".tag").css(".title").css("em").text
            # begin
              # deal_title = item.css(".tag").css(".title").text.delete!("\t").delete!("\n").delete(deal_description)
            # rescue
              # title = item.css(".tag").css(".title").to_s
              # title_s_index = title.index("</em>") + 5
              # title_e_index = title.size
              # deal_title = title[title_s_index..title_e_index].delete!("\t").delete!("\n").delete("</span>")
            # end
            # deal_price = item.css(".price_info").css(".price").css("strong").text.scan(/\d/).join('').to_i
            # deal_original_price = item.css(".price_info").css(".price").css("del").text.scan(/\d/).join('').to_i
            # special_price = item.css(".price_info").css(".price").css("em").text
            # discount = item.css(".price_info").css(".sale").text.scan(/\d/).join('').to_i
#               
            # like_count = item.css("#fcnt#{item_id}").text.scan(/\d/).join('').to_i
            # deal_count = item.css(".count_item").css("strong").text
#               
            # card_interest_description = ""
            # deliver_charge_description = item.css(".ico_tag4").text
#               
            # deal_start = Date.today if item.css(".ico_tag2").text != ""
#               
            # # ActiveRecord::Base.transaction do
            # deal_item = DealItem.create(deal_search_word_id: 10001, item_id: item_id, site_id: site_id, deal_url: deal_url, deal_image: deal_image, deal_description: deal_description, 
                                  # like_count: like_count, discount: discount, deal_original_price: deal_original_price, deal_start: deal_start, special_price: special_price,
                                  # deal_title: deal_title, deal_price: deal_price, deal_count: deal_count, card_interest_description: card_interest_description, deliver_charge_description: deliver_charge_description)
            # # end
            # unless deal_title.include?("지류")
              # Event.create(event_id: item_id, event_name: deal_title, event_url: deal_url, event_site_id: site_id, image_url: deal_image, price: deal_price, original_price: deal_original_price, 
                            # discount: discount, show_flg: true, push_flg: false, update_flg: true, deal_search_word_id: 10001)
            # end
          # end
        # end
#         
      # rescue => e
        # pp e.backtrace
      # end
#       
#         
      # #커피
      # urls = [
              # "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/1",#스타벅스 
              # "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/538",#커피빈 
              # "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/3",#공차
              # "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/7410", #이디야
              # "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/5", #엔젤
              # "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/6", #투썸
              # "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/7", #폴바셋
              # "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/8", #파스구찌
              # "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/9", #할리스
              # "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/4", #베네
              # "http://m.g9.co.kr/Simple.htm#/Display/ECouponLP/658" #오설록 
            # ]
      # cafe_names = ["스타벅스","커피빈","공차","이디야","엔젤리너스","투썸","폴바셋","파스구찌","할리스","카페베네","오설록"]
      # urls.each_with_index do |url, url_i|
#         
        # browser.goto url
        # sleep 1
        # doc = Nokogiri::HTML.parse(browser.html)
        # pages = doc.css(".page_btnbx").css(".ng-binding.ng-scope")
        # pages = [1] if pages.blank?
        # pages.each_with_index do |page, i|
          # unless pages.size == 1
            # browser.span(:text => "#{i+1}").click
            # sleep 1
          # end
          # doc = Nokogiri::HTML.parse(browser.html)
          # g9_item_list = doc.css(".lst_ecpn3").css("li")
          # g9_item_list.each do |item|
            # # item_id = item.css(".img_box").css("img").attr("src").value.split("/g/")[1].split('/')[0]
            # item_id = item.css(".img_box").css("img")[0].attributes["data-original"].value.split("/")[-2]
            # deal_item = DealItem.where(item_id: item_id, site_id: site_id)
#               
            # if deal_item.blank?
              # deal_url = "http://www.g9.co.kr/Display/VIP/Index/" + item_id.to_s
              # deal_image = "http://image.g9.co.kr/g/" + item_id.to_s + "/o"
#                 
              # # deal_description = item.css(".tag").css(".title").css("em").text
              # deal_title = "[" + cafe_names[url_i] + "] " +  item.css(".tit.ng-binding").text
              # deal_price = item.css(".price.ng-binding").text.scan(/\d/).join('').to_i
#               
              # deal_original_price = item.css(".per_price.ng-binding.ng-scope").text.scan(/\d/).join('').to_i
              # deal_original_price = "" if deal_original_price == 0
#               
              # special_price = item.css(".txt.ng-scope").text
#               
              # discount = item.css(".per.ng-binding.ng-scope").text.scan(/\d/).join('').to_i
              # discount = "" if discount == 0
#                 
              # # like_count = item.css("#fcnt#{item_id}").text.scan(/\d/).join('').to_i
              # # deal_count = item.css(".count_item").css("strong").text
#                 
              # # card_interest_description = ""
              # # deliver_charge_description = item.css(".ico_tag4").text
#                 
              # # deal_start = Date.today if item.css(".ico_tag2").text != ""
#                 
              # # ActiveRecord::Base.transaction do
              # deal_item = DealItem.create(deal_search_word_id: 10002, item_id: item_id, site_id: site_id, deal_url: deal_url, deal_image: deal_image, 
                                    # discount: discount, deal_original_price: deal_original_price, special_price: special_price,
                                    # deal_title: deal_title, deal_price: deal_price)
#               
              # Event.create(event_id: item_id, event_name: deal_title, event_url: deal_url, event_site_id: site_id, image_url: deal_image, price: deal_price, original_price: deal_original_price, 
                              # discount: discount, show_flg: true, update_flg: true, deal_search_word_id: 10002, item_type_code: url_i)
              # # end
            # end
          # end            
        # end
      # end
#       
      # url = "http://www.g9.co.kr"
      # browser.goto url
      # browser.goto url
      # # browser.link(:onclick=>"close_regpop();").click
      # search_key.each do |key|
        # p "지구 데이터 수집중 #{key.word}"
        # browser.text_field(:id => 'txtSearchKeyword').set key.word
        # browser.input(:id => "btnSearchKeyword").click
        # browser.a(:text => "최신순").click
#         
        # (1..50).each{|num|
          # # browser.span(:class => 'thumbs').img.wait_until_present
          # browser.execute_script("window.scrollBy(0,1000)")
          # # sleep 1
        # }
#         
        # doc = Nokogiri::HTML.parse(browser.html)
        # g9_item_list = doc.css("#searchItemList").css("li")
        # g9_item_list.each do |item|
          # item_id = item.css(".tag").attr("href").value.split("/")[-1].to_i
          # deal_item = DealItem.where(item_id: item_id, site_id: site_id)
#           
          # if deal_item.blank?
            # deal_url = url + item.css(".tag").attr("href").value
            # # deal_image = item.css("#img#{item_id}").attr("src").value
            # deal_image = "http://image.g9.co.kr/g/" + item_id.to_s + "/o"
#             
            # deal_description = item.css(".tag").css(".title").css("em").text
            # begin
              # deal_title = item.css(".tag").css(".title").text.delete!("\t").delete!("\n").delete(deal_description)
            # rescue
              # title = item.css(".tag").css(".title").to_s
              # title_s_index = title.index("</em>") + 5
              # title_e_index = title.size
              # deal_title = title[title_s_index..title_e_index].delete!("\t").delete!("\n").delete("</span>")
            # end
            # deal_price = item.css(".price_info").css(".price").css("strong").text.scan(/\d/).join('').to_i
            # deal_original_price = item.css(".price_info").css(".price").css("del").text.scan(/\d/).join('').to_i
            # special_price = item.css(".price_info").css(".price").css("em").text
            # discount = item.css(".price_info").css(".sale").text.scan(/\d/).join('').to_i
#             
            # like_count = item.css("#fcnt#{item_id}").text.scan(/\d/).join('').to_i
            # deal_count = item.css(".count_item").css("strong").text
#             
            # card_interest_description = ""
            # deliver_charge_description = item.css(".ico_tag4").text
#             
            # deal_start = Date.today if item.css(".ico_tag2").text != ""
#             
            # # ActiveRecord::Base.transaction do
            # deal_item = DealItem.create(deal_search_word_id: key.id, item_id: item_id, site_id: site_id, deal_url: deal_url, deal_image: deal_image, deal_description: deal_description, 
                                  # like_count: like_count, discount: discount, deal_original_price: deal_original_price, deal_start: deal_start, special_price: special_price,
                                  # deal_title: deal_title, deal_price: deal_price, deal_count: deal_count, card_interest_description: card_interest_description, deliver_charge_description: deliver_charge_description)
            # # end
            # search_result = DealSearchResult.where(deal_item_id: deal_item.id, deal_search_word: key.word)
            # DealSearchResult.create(deal_item_id: deal_item.id, deal_search_word: key.word) if search_result.blank?
          # else
            # search_result = DealSearchResult.where(deal_item_id: deal_item[0].id, deal_search_word: key.word)
            # DealSearchResult.create(deal_item_id: deal_item[0].id, deal_search_word: key.word) if search_result.blank?  
          # end
        # end
      # end
      return true
    rescue => e
      pp e.backtrace
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
  
  def self.add_auction(browser)
    begin
      site_id = 1006
      url = "http://listings.auction.co.kr/category/List.aspx?category=86030100"
      browser.goto url
      browser.div(:id => "ucAttributeIndexBox1_rAttributeSet_hdivMoreView_0").click #더보기
            
      # click_ids = [ 
                    # "chkElement__ctl0_-1_19721", #스타벅스0
                    # "chkElement__ctl0_-1_498284", #베네9
                    # "chkElement__ctl0_-1_19728", #투썸5
                    # "chkElement__ctl0_-1_896045", #파스구찌7
                    # "chkElement__ctl0_-1_19725", #엔젤4
                    # "chkElement__ctl0_-1_19723", #할리스8
                    # "chkElement__ctl0_-1_23703", #오설록10
                    # "chkElement__ctl0_-1_19729", #커피빈1
                    # "chkElement__ctl0_-1_1647224", #폴바셋6
                    # "chkElement__ctl0_-1_1647247", #공차2
                    # "" #3
                  # ]
      cafe_names = ["스타벅스","카페베네","투썸플레이스","파스쿠찌","엔제리너스","할리스커피","오설록","커피빈","폴바셋","공차",""]
      item_type_codes = [0, 9, 5, 7, 4, 8, 10, 1, 6, 2, 3]
      cafe_names.each_with_index do |name, index|
        if index == 0
          browser.scroll.to :top
          browser.div(:class => "ck_list").label(:text, name).click
        elsif index == 9
          url = "http://through.auction.co.kr/common/SafeRedirect.aspx?cc=0FA0&LPFwc=86030100&next=http://listings.auction.co.kr/category/List.aspx?category=86030300"
          browser.goto url
          browser.div(:class => "ck_list").label(:text, name).click
        elsif index == 10
          browser.text_field(:id => 'keywordRetry').set "이디야"
          browser.input(:class => 'btn_cg_sc').click
        else
          browser.div(:class => "ck_list").label(:text, name).click
        end
        
        # self.wait_auction(browser)
        sleep 2
        
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
              # self.wait_auction(browser)
              sleep 2
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
            
            deal_image[-5] = "5" if deal_image[-5] == "2"
                  
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
          browser.div(:class => "ck_list").label(:text, name).click
          # self.wait_auction(browser)
          sleep 2
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
          price = li.css("b")[0].text.scan(/\d/).join('').to_i
          # price.lstrip!
          original_price = li.css("s").text
          event_name = "[메가박스]" + title 
          event_url = url
          image_url = li.css(".img_pro").attr("src").value
        
          if title.include?("1+1")
            Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price, 
                            show_flg: true, push_flg: true, update_flg: true, deal_search_word_id: 10001)
          else
            # Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price)
          end
        else
          unless li.css(".tx_soldout").blank?
            event.update_all(show_flg: false)
          end
            
        end
      end
      return true
    rescue => e
      return false
    end
  end
  
  def self.movie_event_lotteciname(browser)
    begin
      url = "http://event.lottecinema.co.kr/LCHS/Contents/Event/event-summary-list.aspx"
      browser.goto url
      event_site_id = 4002
      
      doc = Nokogiri::HTML.parse(browser.html)
      list = doc.css("ul#emovie_list_20 li")
      list.each do |li|
        event_id = li.css(".event a").attr("onclick").value.split("(")[1].split(",")[0].scan(/\d/).join('').to_i
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        if event.blank?
          title = li.css(".event").text
          # price.lstrip!
          event_name = "[롯데시네마]" + title 
          event_url = url
          image_url = li.css("a img")[0].attr("src")
        
          if title.include?("얼리버드")
            Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, 
                            show_flg: true, push_flg: true, update_flg: true, deal_search_word_id: 10001)
          else
            # Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price)
          end
        else
        end
      end
      return true
    rescue => e
      return false
    end
    
  end
  
  def self.add_tmon_super_ggul(browser)
    begin
      url = "http://m.search.ticketmonster.co.kr/search/result?keyword=%EC%8A%88%ED%8D%BC%EA%BF%80%EB%94%9C"
      browser.goto url
      event_site_id = 9001
      
      doc = Nokogiri::HTML.parse(browser.html)      
      begin
        browser.button(:id =>'_btnCloseCateInfoLayer').click
        doc = Nokogiri::HTML.parse(browser.html)
      rescue
      end
      
      lis = doc.css("#dealList li")
      li = lis[0]
      # lis.each do |li|
        event_url = li.css(".deal_item_anchor").attr("href").value
        event_id = event_url.split("//")[1].split("?")[0].split("/")[3]
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        if event.blank?
          title = li.css(".deal_item_title").text.strip
          price = li.css(".deal_item_price").text.split(" ")[0].scan(/\d/).join('').to_i
          original_price = li.css(".deal_item_price_cover").text
          discount = li.css(".deal_item_discount").text
          event_name = title 
          
          image_url = li.css(".deal_item_thumb img").attr("src").value
          Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, 
                        price: price, original_price: original_price, discount: discount, show_flg: true, push_flg: true, update_flg: true, deal_search_word_id: 9001)
        else
          # if li.css(".type2 .blind").text == "매진"
            # event.update_all(show_flg: false)
          # else
            # event.update_all(show_flg: true)
          # end
        end
      # end
      return true
    rescue => e
      pp e.backtrace
      return false
    end
  end
  
  def self.gs25(browser)
    begin
      # browser = Watir::Browser.new
      # DealItem.gs25(browser)
      p "GS25..."
      url = "http://gs25.gsretail.com/gscvs/ko/products/event-goods"
      conveni_name = "gs25"
      browser.goto url
      browser.a(:id =>'TOTAL').click
      
      doc = Nokogiri::HTML.parse(browser.html)
      end_index = doc.css(".next2").attr("onclick").value.split("(")[1].split(")")[0].to_i
      
      box_kind_size = doc.css(".prod_list").size
      items = doc.css(".prod_list")[box_kind_size-1].css("li")
      
      p "GS25 데이터 처리중..."
      for i in 0..end_index - 1
        sleep 1
        doc = Nokogiri::HTML.parse(browser.html)
        box_kind_size = doc.css(".prod_list").size
        items = doc.css(".prod_list")[box_kind_size-1].css("li")
        items.each do |item|
          begin
            item_type = item.css(".flg01 span").text
            item_type = "gift" if item_type == "덤증정"        
            image_url = item.css("img").attr("src").value
            name = item.css(".tit")[0].text
            price = item.css(".cost")[0].text.scan(/\d/).join('').to_i
            gift_image_url = nil
            gift_name = nil
            gift_price = nil
            if item_type == "gift"
              gift_image_url = nil
              gift_name = nil
              gift_price = nil
              begin
                gift_image_url = item.css(".dum_prd img").attr("src").value
                gift_name = item.css(".dum_txt .name").text
                gift_price = item.css(".dum_txt .price").text.scan(/\d/).join("").to_i
              rescue
              end
            end
            ConvenienceItem.create(item_type: item_type, image_url: image_url, name: name, price: price, gift_image_url: gift_image_url, gift_name: gift_name, gift_price: gift_price, conveni_name: conveni_name)
          rescue
          end
        end
        browser.link(:class =>'next', :index => box_kind_size).click
      end
      return true
    rescue
      return false
    end
  end
  
  def self.cu(browser)
    begin
      # browser = Watir::Browser.new
      # DealItem.cu(browser)
      p "CU..."
      conveni_name = "cu"
      url = "http://cu.bgfretail.com/event/plus.do?category=event&depth2=1&sf=N"
      browser.goto url
      
      #로딩 끝날때까지 기다림.
      begin
        while browser.div(:class => 'AjaxLoading').visible? do
          sleep 0.2
        end
      rescue
      end
      
      #더보기 버튼이 없을때까지 클릭
      p "CU 페이지 로딩..."
      begin
        while browser.a(:text => '더보기').visible? do
          browser.a(:text=>'더보기').click
          while browser.div(:class => 'AjaxLoading').visible? do
            sleep 0.2
          end
        end
      rescue
      end
      
      p "CU 1+1 2+1 데이터 처리중..."
      doc = Nokogiri::HTML.parse(browser.html)
      items = doc.css(".prodListWrap li")
      items.each_with_index do |item, index|
        begin
          image_url = item.css(".photo img").attr("src").value
          name = item.css(".prodName").text
          price = item.css(".prodPrice").text.scan(/\d/).join('').to_i
          item_type = item.css("li")[0].text
          ConvenienceItem.create(item_type: item_type, image_url: image_url, name: name, price: price, conveni_name: conveni_name)
        rescue
        end
      end
      
      
      #증정품
      url = "http://cu.bgfretail.com/event/present.do?category=event&depth2=5"
      browser.goto url
      #로딩 끝날때까지 기다림.
      begin
        while browser.div(:class => 'AjaxLoading').visible? do
          sleep 0.2
        end
      rescue
      end
      
      # begin
        # while browser.a(:text => '더보기').visible? do
          # browser.a(:text=>'더보기').click
          # while browser.div(:class => 'AjaxLoading').visible? do
            # sleep 0.2
          # end
        # end
      # rescue
      # end
      
      p "CU gift 처리중..."
      doc = Nokogiri::HTML.parse(browser.html)
      items = doc.css(".presentListBox")
      items.each_with_index do |item, index|
        image_url = item.css(".presentList-w .photo img").attr("src").value
        name = item.css(".presentList-w .prodName").text
        price = item.css(".presentList-w .prodPrice").text.scan(/\d/).join('').to_i
        item_type = "gift"
        
        gift_image_url = item.css(".presentList-e .photo img").attr("src").value
        gift_name = item.css(".presentList-e .prodName").text
        gift_price = item.css(".presentList-e .prodPrice").text.scan(/\d/).join('').to_i
        ConvenienceItem.create(item_type: item_type, image_url: image_url, name: name, price: price, gift_image_url: gift_image_url, gift_name: gift_name, gift_price: gift_price, conveni_name: conveni_name)
      end
      return true
    rescue
      return false
    end
    
  end
  
  
  def self.seven_eleven(browser)
    begin
      head_url = "http://www.7-eleven.co.kr"
      # browser = Watir::Browser.new
      # DealItem.seven_eleven(browser)
      url = "https://www.7-eleven.co.kr/product/presentList.asp"
      conveni_name = "seven_eleven"
      browser.goto url
  #     1+1
      browser.execute_script("document.getElementById('header').style.position='absolute';")
      p "세븐일레븐 1+1 데이터 수집중..."
      err_cnt = 0
      for i in 0..1000
        begin
          browser.execute_script("document.getElementById('header').style.position='absolute';")
          browser.a(:text => 'MORE').click
          sleep 0.5
        rescue => e
          err_cnt += 1
          break if(err_cnt > 3)
        end
      end
      # begin
        # while browser.a(:text => 'MORE').visible? do
          # browser.execute_script("document.getElementById('header').style.position='absolute';")
          # browser.a(:text=>'MORE').click
          # sleep 2
        # end
      # rescue
      # end
      doc = Nokogiri::HTML.parse(browser.html)
      items = doc.css("#listUl")
      items = items.xpath("li")
      p "세븐일레븐 1+1 데이터 생성중......................................................................"
      items.each do |item|
        begin
        item_type = "1+1"
        image_url = head_url + item.css(".pic_product img").attr("src").value
        name = item.css(".name").text
        price = item.css(".price").text.scan(/\d/).join('').to_i
        ConvenienceItem.create(item_type: item_type, image_url: image_url, name: name, price: price, conveni_name: conveni_name)
        rescue
        end
      end
      
      
  #     2+1
      browser.execute_script("document.getElementById('header').style.position='absolute';")
      browser.div(:class => "wrap_tab").a(:text => "2+1").click
      p "세븐일레븐 2+1 데이터 수집중......................................................................"
      err_cnt = 0
      for i in 0..1000
        begin
          browser.execute_script("document.getElementById('header').style.position='absolute';")
          browser.a(:text => 'MORE').click
          sleep 0.5
        rescue
          err_cnt += 1
          break if(err_cnt > 3)
        end
      end
      
      # begin
        # while browser.a(:text => 'MORE').visible? do
          # # debugger
          # browser.execute_script("document.getElementById('header').style.position='absolute';")
          # browser.a(:text=>'MORE').click
          # sleep 2
        # end
      # rescue => e
        # pp e.backtrace
        # p "error"
      # end
      
      doc = Nokogiri::HTML.parse(browser.html)
      items = doc.css("#listUl")
      items = items.xpath("li")
      p "세븐일레븐 2+1 데이터 생성중..."
      items.each do |item|
        begin
        item_type = "2+1"
        image_url = head_url + item.css(".pic_product img").attr("src").value
        name = item.css(".name").text
        price = item.css(".price").text.scan(/\d/).join('').to_i
        ConvenienceItem.create(item_type: item_type, image_url: image_url, name: name, price: price, conveni_name: conveni_name)
        rescue
        end
      end
      
  #     증정
      browser.execute_script("document.getElementById('header').style.position='absolute';")
      browser.div(:class => "wrap_tab").a(:text => "증정행사").click
      p "세븐일레븐 증정 데이터 수집중......................................................................"
      
      err_cnt = 0
      for i in 0..1000
        begin
          browser.execute_script("document.getElementById('header').style.position='absolute';")
          browser.a(:text => 'MORE').click
          sleep 0.5
        rescue
          err_cnt += 1
          break if(err_cnt > 3)
        end
      end
      # begin
        # while browser.a(:text => 'MORE').visible? do
          # # debugger
          # browser.execute_script("document.getElementById('header').style.position='absolute';")
          # browser.a(:text=>'MORE').click
          # sleep 2
        # end
      # rescue => e
        # pp e.backtrace
        # p "error"
      # end
      
      doc = Nokogiri::HTML.parse(browser.html)
      items = doc.css("#listUl")
      items = items.xpath("li")
      p "세븐일레븐 증정 데이터 생성중..."
      items.each do |item|
        begin
          item_type = "gift"
          ori_item = item.css(".pic_product")[0]
          image_url = head_url + ori_item.css("img").attr("src").value
          name = ori_item.css(".name").text
          price = ori_item.css(".price").text.scan(/\d/).join('').to_i
          
          gift_item = item.css(".pic_product")[1]
          gift_image_url = head_url + gift_item.css("img").attr("src").value
          gift_name = gift_item.css(".name").text
          gift_price = gift_item.css(".price").text.scan(/\d/).join('').to_i
          ConvenienceItem.create(item_type: item_type, image_url: image_url, name: name, price: price, gift_image_url: gift_image_url, gift_name: gift_name, gift_price: gift_price, conveni_name: conveni_name)
        rescue
        end
      end
      return true
    rescue
      return false
    end
  end
  
  
  def self.mini_stop(browser)
    begin
      # browser = Watir::Browser.new
      # DealItem.mini_stop(browser)
      p "미니스탑..."
      head_url = "http://minihomepage.cloudapp.net/MiniStopHomePage/page"
      url = "http://minihomepage.cloudapp.net/MiniStopHomePage/page/event/plus1.do"
      conveni_name = "mini_stop"
      browser.goto url
      
      err_cnt = 0
      for i in 0..20
        begin
          browser.a(:text => '더보기').click
          sleep 0.2
        rescue
          err_cnt += 1
          break if(err_cnt > 3)
        end
      end
      
      p "미니스탑 1+1데이터 처리중..."
      doc = Nokogiri::HTML.parse(browser.html)
      items = doc.css(".event_plus_list li")
      items.each do |item|
        item_type = "1+1"
        image_url = item.css("img").attr("src").value
        image_url = head_url + image_url[2..image_url.size - 1]
        
        name = item.css("p").to_s
        tmp_ary = name.split("<br>")
        name = tmp_ary[0].delete("<p>")
        
        price = item.css("strong").text.scan(/\d/).join('').to_i
        ConvenienceItem.create(item_type: item_type, image_url: image_url, name: name, price: price, conveni_name: conveni_name)
      end
      
  #     2+1
      browser.a(:text => '2 + 1').click
      err_cnt = 0
      for i in 0..20
        begin
          browser.a(:text => '더보기').click
          sleep 0.2
        rescue
          err_cnt += 1
          break if(err_cnt > 3)
        end
      end
      
      p "미니스탑 2+1데이터 처리중..."
      doc = Nokogiri::HTML.parse(browser.html)
      items = doc.css(".event_plus_list li")
      items.each do |item|
        item_type = "2+1"
        image_url = item.css("img").attr("src").value
        image_url = head_url + image_url[2..image_url.size - 1]
        
        name = item.css("p").to_s
        tmp_ary = name.split("<br>")
        name = tmp_ary[0].delete("<p>")
        
        price = item.css("strong").text.scan(/\d/).join('').to_i
        ConvenienceItem.create(item_type: item_type, image_url: image_url, name: name, price: price, conveni_name: conveni_name)
      end
      
      # 덤증정
      browser.ul(:class => "section_menu_tab guide").a(:text => '덤증정').click
      err_cnt = 0
      for i in 0..20
        begin
          browser.a(:text => '더보기').click
          sleep 0.2
        rescue
          err_cnt += 1
          break if(err_cnt > 3)
        end
      end
      
      doc = Nokogiri::HTML.parse(browser.html)
      
      p "미니스탑 gift 데이터 처리중..."
      items = doc.css(".event_add_list li")
      items.each do |item|
        item_type = "gift"
        ori_item = item.css(".add_left")
        image_url = ori_item.css("img").attr("src").value
        image_url = head_url + image_url[2..image_url.size - 1]
        
        name = ori_item.css("p").to_s
        tmp_ary = name.split("<br>")
        name = tmp_ary[0].delete("<p>")
        
        price = ori_item.css("strong").text.scan(/\d/).join('').to_i
        
        
        gift_item = item.css(".add_right")
        gift_image_url = gift_item.css("img").attr("src").value
        gift_image_url = head_url + gift_image_url[2..gift_image_url.size - 1]
        
        gift_name = gift_item.css("p").to_s
        tmp_ary = gift_name.split("<br>")
        gift_name = tmp_ary[0].delete("<p>")
        
        gift_price = gift_item.css("strong").text.scan(/\d/).join('').to_i
        ConvenienceItem.create(item_type: item_type, image_url: image_url, name: name, price: price, gift_image_url: gift_image_url, gift_name: gift_name, gift_price: gift_price, conveni_name: conveni_name)
      end
      return true
    rescue
      return false
    end
    
  end
  
  #####################################################################
  def self.read_11st(browser)
    cnt = 0
    begin
      url = "http://www.11st.co.kr/html/main.html"
      browser.goto url
      doc = Nokogiri::HTML.parse(browser.html)
      # list = doc.css("#rankList4 li")
      
      list = doc.css("#rakingWrap li.selected ol li")
      cnt += list.size
      (0..3).each do |num|
        event_id =  list[num].css("a").attr("href").value.split(',')[-2].split("'")[1]
        event_url = "http://www.11st.co.kr/html/bestSellerMain4.html?prdNo=#{event_id}"
              
        event_name = list[num].css("p").text
        price = list[num].css("a em").text.scan(/\d/).join('').to_i
        image_url = list[0].css("img").attr("src").value
        if price < 3000
          event = Event.where(event_id: event_id)
          if event.blank?
            Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: 9999, price: price, show_flg: false, push_flg: true, update_flg: true, image_url: image_url)
            Ppomppu.send_read_push(event_name, price, event_url)
          end
        end
      end
      
      list = doc.css("#shockingDealPrdWrap li")
      cnt += list.size
      list.each do |li|
        image_url =  li.css(".thumb_prd img").attr("src").value
        event_id =  li.css("a").attr("href").value.split("prdNo=")[1].split("&")[0]
        event_url = li.css("a").attr("href").value
        event_name = li.css(".prd_info p").text
        price = li.css(".price_wrap strong").text.scan(/\d/).join('').to_i
        if price < 3000
          event = Event.where(event_id: event_id)
          if event.blank?
            Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: 9999, price: price, show_flg: false, push_flg: true, update_flg: true, image_url: image_url)
            Ppomppu.send_read_push(event_name, price, event_url)
          end
        end
      end
      p "total: #{cnt}"
      return true
    rescue
      return false
    end
  end
  
  def self.read_g9(browser)
    cnt = 0
    begin
      url = "http://www.g9.co.kr"
      browser.goto url
      
      browser.li(:class =>'today').click
      
      
      # sleep 1
      
      doc = Nokogiri::HTML.parse(browser.html)
      # list = doc.css("#goods_list1775 li")
      list = doc.css("#today_deal .list_v3.default_v3 ul li")
      cnt += list.size
      list.each do |li|
        if li.css(".ico_soldout").blank?
          event_url = "http://www.g9.co.kr" + li.css(".tag").attr("href").value
          event_id = event_url.split("/")[-1]
          
          event_name = li.css(".subject").text
          event_name = event_name.delete!("\n") if event_name.include?("\n")
          event_name = event_name.delete!("\t") if event_name.include?("\t")
          price = li.css(".price").text.scan(/\d/).join('').to_i
          image_url = li.css(".tag .thumbs img").attr("src").value
          if price < 3000
            event = Event.where(event_id: event_id)
            if event.blank?
              Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: 9999, price: price, show_flg: false, push_flg: true, update_flg: true, image_url: image_url)
              Ppomppu.send_read_push(event_name, price, event_url)
            end
          end
        end
      end
      p "total: #{cnt}"
      return true
    rescue => e
      pp e.backtrace
      return false
    end
  end
  
  def self.read_auction(browser)
    cnt = 0
    begin
      url = "http://www.auction.co.kr"
      browser.goto url
      
      doc = Nokogiri::HTML.parse(browser.html)
      list = doc.css("#touchSlider_allkill li")
      cnt += list.size
      list.each do |li|
        event_url = li.css(".allkill_box a").attr("href").value
        event_id = event_url.split("itemno=")[1]
        event_name = li.css(".allkill_box").text
        price = li.css(".price_box .price_ing").text.scan(/\d/).join('').to_i
        image_url = li.css(".inner .item_img_type1 a img").attr("data-original").value
        if price < 3000
          event = Event.where(event_id: event_id)
          if event.blank?
            Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: 9999, price: price, show_flg: false, push_flg: true, update_flg: true, image_url: image_url)
            Ppomppu.send_read_push(event_name, price, event_url)
          end
        end
      end
      
      list = doc.css("#touchSlider_thema_1 li")
      cnt += list.size
      list.each do |li|
        event_url = li.css(".allkill_box a").attr("href").value
        event_id = event_url.split("itemno=")[1]
        event_name = li.css(".allkill_box").text
        event_name.delete!("\t") if event_name.include?("\t")
        price = li.css(".price_box .price_ing").text.scan(/\d/).join('').to_i
        image_url = li.css(".inner .item_img_type1 .img_box.h_type3 .item_img.lazy").attr("src").value
        if price < 3000
          event = Event.where(event_id: event_id)
          if event.blank?
            Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: 9999, price: price, show_flg: false, push_flg: true, update_flg: true, image_url: image_url)
            Ppomppu.send_read_push(event_name, price, event_url)
          end
        end
        
      end
      
      list = doc.css("#touchSlider_thema_2 li")
      cnt += list.size
      list.each do |li|
        event_url = li.css(".allkill_box a").attr("href").value
        event_id = event_url.split("itemno=")[1]
        event_name = li.css(".allkill_box").text
        event_name.delete!("\t") if event_name.include?("\t")
        price = li.css(".price_box .price_ing").text.scan(/\d/).join('').to_i
        image_url = li.css(".inner .item_img_type1 .img_box.h_type3 .item_img.lazy").attr("src").value
        if price < 3000
          event = Event.where(event_id: event_id)
          if event.blank?
            Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: 9999, price: price, show_flg: false, push_flg: true, update_flg: true, image_url: image_url)
            Ppomppu.send_read_push(event_name, price, event_url)
          end
        end
      end
      
      list = doc.css("#touchSlider_best li a")
      cnt += list.size
      list.each do |a|
        # A971384216
        event_url = a.attr("href")
        event_id = event_url.split("selecteditemno%3D")[1]
        event_url = "http://itempage3.auction.co.kr/detailview.aspx?ItemNo=#{event_id}"
        event_name = a.css(".showcace_info .text_type1").text
        price = a.css(".showcace_info em").text.scan(/\d/).join('').to_i
        image_url = a.css(".showcase_img .item_img.lazy").attr("data-original").value
        if price < 3000
          event = Event.where(event_id: event_id)
          if event.blank?
            Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: 9999, price: price, show_flg: false, push_flg: true, update_flg: true, image_url: image_url)
            Ppomppu.send_read_push(event_name, price, event_url)
          end
        end
      end
      
      
      list = doc.css(".mystyle_con li")
      cnt += list.size
      list.each do |li|
        event_url = li.css(".showcase_img a").attr("href").value
        event_id = event_url.split("itemno=")[1]
        event_name = li.css(".showcace_info a")[0].text
        price = li.css(".showcace_info a")[1].text.scan(/\d/).join('').to_i
        image_url = li.css(".showcase_img .item_img.lazy").attr("data-original").value
        if price < 3000
          event = Event.where(event_id: event_id)
          if event.blank?
            Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: 9999, price: price, show_flg: false, push_flg: true, update_flg: true, image_url: image_url)
            Ppomppu.send_read_push(event_name, price, event_url)
          end
        end
      end
      p "total: #{cnt}"
      return true
    rescue => e
      pp e.backtrace
      return false
    end
  end
  
  
  def self.read_wemakeprice(browser)
    cnt = 0
    begin
      url = "http://www.wemakeprice.com/"
      browser.goto url
      begin
        browser.link(:onclick=>"close_regpop();").click
      rescue
      end
      
      doc = Nokogiri::HTML.parse(browser.html)
      
      list = doc.css("#today_pick_cont li")
      cnt += list.size
      list.each do |li|
        event_url = li.css("a").attr("href").value
        event_id = event_url.split("?")[0].split("/")[-1]
        image_url = li.css("img").attr("src").value
        event_name = li.css("img").attr("alt").value
        price = li.css(".price .num").text.scan(/\d/).join('').to_i
        if price < 3000
          event = Event.where(event_id: event_id)
          if event.blank?
            Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: 9999, price: price, show_flg: false, push_flg: true, update_flg: true, image_url: image_url)
            Ppomppu.send_read_push(event_name, price, event_url)
          end
        end
      end
      
      list = doc.css("#wrap_main_best_area li")
      cnt += list.size
      list.each_with_index do |li, i|
        # http://www.wemakeprice.com/deal/adeal/1001765?source=todaypick&no=1
        next unless li.attr("item_id")
        event_url = "http://www.wemakeprice.com" + li.css("a").attr("href").value
        event_id = li.css("a").attr("href").value.split("?")[0].split("/")[-1]
        image_url = li.css(".box_thumb img").attr("src").value
        event_name = li.css(".tit_desc").text
        price = li.css(".sale").text.scan(/\d/).join('').to_i
        if price < 3000
          event = Event.where(event_id: event_id)
          if event.blank?
            Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: 9999, price: price, show_flg: false, push_flg: true, update_flg: true, image_url: image_url)
            Ppomppu.send_read_push(event_name, price, event_url)
          end
        end
      end
      p "total: #{cnt}"
      return true
    rescue => e
      pp e.backtrace
      return false
    end
  end  
  
end
