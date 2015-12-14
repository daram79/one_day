# coding : utf-8
require 'open-uri'
class Event < ActiveRecord::Base
  
  after_create :send_push
  after_update :send_push
  
  def send_push
    if self.push_flg
      Thread.new do
        gcm = GCM.new("AIzaSyD_3jJfuO8NT8G-kDHcmTiwl3w0W1JuxXQ")
        user_ids = EventMailingList.all.ids
        option = { :data => {'message' => self.event_name} }
        registration_ids = EventUserRegistrations.where(event_user_id: user_ids).pluck(:registration_id)
        gcm.send(registration_ids, option) unless registration_ids.blank?
      end
    end
  end
  
  def self.get_clien_sale_data(event_site_id)
    begin
      first_url = "http://m.clien.net/cs3/board"
      url = "http://m.clien.net/cs3/board?bo_style=lists&bo_table=jirum"
      html_str = open(url).read
      
      doc = Nokogiri::HTML(html_str)
      
      divs = doc.css("div.wrap_tit")
      
      event_ary = []
      divs.each do |div|
        if div.attributes["onclick"]
          event_id = div.attributes["onclick"].value.split('&')[2]
          event_id.slice! "wr_id="
          event_name = div.css("span.lst_tit").text
          event_url = first_url + div.attributes["onclick"].value.split("'")[1]
          
          event = Event.where(event_id: event_id, event_site_id: event_site_id)
          
          if event.blank?
            Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id)
            event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
            event_ary.push event_hash
          end
        end
      end
      event_ary
    rescue => e
      p e.backtrace
      return event_ary = []
    end
  end
  
  def self.get_clien_event_data(event_site_id)
    begin
      first_url = "http://m.clien.net/cs3/board"
      url = "http://m.clien.net/cs3/board?bo_style=lists&bo_table=coupon"
      
      html_str = open(url).read
      doc = Nokogiri::HTML(html_str)
      divs = doc.css("div.wrap_tit")
      
      event_ary = []
      
      divs.each do |div|
        if div.attributes["onclick"]
          event_id = div.attributes["onclick"].value.split('&')[2]
          event_id.slice! "wr_id="
          event_name = div.css("span.lst_tit").text
          event_url = first_url + div.attributes["onclick"].value.split("'")[1]
          
          event = Event.where(event_id: event_id, event_site_id: event_site_id)
          
          if event.blank?
            Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id)
            event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
            event_ary.push event_hash
          end
        end
      end
      event_ary
    rescue => e
      p e.backtrace
      return event_ary = []
    end
  end
  
  def self.get_naver_sg_data(event_site_id)
    begin
      first_url = "http://cafe.naver.com"
      url = "http://cafe.naver.com/starbucksgossip/ArticleList.nhn?search.clubid=13500915&search.clubid=13500915"
      
      html_str = open(url).read.encode("utf-8", "euc-kr")
      doc = Nokogiri::HTML(html_str)
      
      aaa = doc.css(".aaa a")
      
      event_ary = []
      aaa.each do |a|
        if a.text.include?("행사") || a.text.include?("이벤트")
          no = a.attributes["href"].value.split("&").index {|item| item =~ /^articleid=/ }
          if no
            event_id = a.attributes["href"].value.split("&")[no]
            event_id.slice! "articleid="
            event_name = a.text
            event_url = first_url + a.attributes["href"].value
              
            event = Event.where(event_id: event_id, event_site_id: event_site_id)
              
            if event.blank?
              Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id)
              event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
              event_ary.push event_hash
            end
          end
        end
      end
      event_ary
    rescue => e
      p e.backtrace
      return event_ary = []
    end
  end
  
  def self.get_coex_data(event_site_id)
    begin
      url = "http://www.coex.co.kr/blog/event_exhibition?list_type=list"
      
      html_str = open(url).read
      doc = Nokogiri::HTML(html_str)
      as = doc.css(".article-list a")
      
      event_ary = []
      as.each do |a|
        link_url = a.attributes["href"].value
        no = link_url.split("/").index("event_exhibition")
        event_id = link_url.split("/")[no+1]
        event_name = a.css(".subject").text
        event_url = a.attributes["href"].value
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        if event.blank?
          Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id)
          event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
          event_ary.push event_hash
        end
      end
      event_ary
    rescue => e
      p e.backtrace
      return event_ary = []
    end
  end
  
  def self.get_tmon_todays_hot_area(event_site_id)
    begin
      first_url = "http://www.ticketmonster.co.kr"
      url = "http://www.ticketmonster.co.kr/home"
      
      html_str = open(url).read
      doc = Nokogiri::HTML(html_str)
      sliders = doc.search(".slider_item")
      
      event_ary = []
      sliders.each do |slider|
        title = slider.search(".tit").text
        ary_price = slider.css(".price").text.split("\n")
        
        event_name = "[티몬]" + title
        link_url = slider.css("a")[0].attributes["href"].value
        event_url = first_url + link_url
        event_id = link_url.split("/")[2]
        image_url = slider.css(".thum").css("img")[0].attributes["src"].value
        price = ary_price[0]
        original_price = ary_price[2] ? ary_price[1].strip! : ""
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        if event.blank?
          Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price)
          event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
          event_ary.push event_hash
        end
      end
      event_ary
    rescue => e
      p e.backtrace
      return event_ary = []
    end
  end
  
  def self.get_shocking_deal_best_main(event_site_id)
    begin
      url = "http://deal.11st.co.kr/browsing/ShockingDealBestAction.tmall?method=shockingDealBestMain"
      html_str = open(url).read
      doc = Nokogiri::HTML(html_str)
      lis = doc.search(".prd_wrap li")
      event_ary = []
      lis.each do |li|
        title = li.css("strong")[0].children[0].text
        price = li.css(".price_wrap strong").text
        original_price = li.css(".price_wrap s").text
        discount = li.css(".sale").text
        
        event_id = li.attributes["prdno"].value
        event_name = "[11번가 쇼킹딜]" + title
        event_url = li.css("a")[0].attributes["href"].value if li.css("a")[0].attributes["href"]
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        image_url = li.css(".thumb_prd").css("img")[0].attributes["src"].value
        if event.blank?
          Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price, discount: discount)
          event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
          event_ary.push event_hash
        end
      end
      event_ary
    rescue => e
      p e.backtrace
      return event_ary = []
    end
  end
  
  def self.get_shocking_deal_today(event_site_id)
    begin
      url = "http://deal.11st.co.kr/browsing/ShockingDealAction.tmall?method=getShockingDealToday"
      html_str = open(url).read
      doc = Nokogiri::HTML(html_str)
      lis = doc.search(".prd_wrap li")
      
      event_ary = []
      lis.each do |li|
        title = li.css("strong")[0].children[0].text
        price = li.css(".price_wrap strong").text
        original_price = li.css(".price_wrap s").text
        discount = li.css(".sale").text
        
        event_id = li.attributes["prdno"].value
        event_name = "[11번가 쇼킹딜]" + title
        event_url = li.css("a")[0].attributes["href"].value if li.css("a")[0].attributes["href"]
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        image_url = li.css(".thumb_prd").css("img")[0].attributes["src"].value
        if event.blank?
          Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price, discount: discount)
          event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
          event_ary.push event_hash
        end
      end
      event_ary
    rescue => e
      p e.backtrace
      return event_ary = []
    end
  end
  
  def self.get_tmon_super_ggul(event_site_id)
    begin
      event_site_id = 9001
      first_url = "http://m.ticketmonster.co.kr"
      url = "http://m.ticketmonster.co.kr/deal?cat=20070759"
      html_str = open(url).read
      doc = Nokogiri::HTML(html_str)
      # lis = doc.search(".prd_wrap li")
      
      event_ary = []
      # lis.each do |li|
      title = doc.css(".lst_dl")[0].css(".info")[0].css(".tit").text
      if title.include?("슈퍼") && title.include?("꿀딜")
        price = doc.css(".lst_dl")[0].css(".info")[0].css(".price")[0].css(".won")[0].css(".sale").text
        original_price = doc.css(".lst_dl")[0].css(".info")[0].css(".price")[0].css(".won")[0].css(".org").text
        discount = doc.css(".lst_dl")[0].css(".info")[0].css(".price")[0].css(".per").text
          
        rear_link_url = doc.css(".lst_dl")[0].css("a")[0].attributes["href"].value
          
        event_id = rear_link_url.split("/")[3].split("?")[0]
        event_name = title
        event_url = first_url + rear_link_url
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        image_url = doc.css(".lst_dl")[0].css(".thm")[0].css("img")[0].attributes["src"].value
        if event.blank?
          Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, 
                          price: price, original_price: original_price, discount: discount, show_flg: true, push_flg: true, update_flg: true)
          event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
          event_ary.push event_hash
        end
      end
      # end
      event_ary
    rescue => e
      p e.backtrace
      return event_ary = []
    end
  end
  
  # move => event_alram_mailer_watir
  # def self.get_g9_flash_deal(event_site_id)
    # begin
      # event_site_id = 9002
      # url = "http://www.g9.co.kr"
      # browser = Watir::Browser.new
      # browser.goto(url)
      # while browser.div(:id=>"bestDealLoding").visible? do sleep 1 end
      # browser.execute_script("window.scrollTo(0, document.body.scrollHeight);\n")
      # doc = Nokogiri::HTML.parse(browser.html)
      # browser.close
      # event_ary = []
      # title = doc.css("#flash_deal_goods_list").css(".title").text.delete!("\n").delete!("\t")
      # price = doc.css("#flash_deal_goods_list").css(".price_info").css(".price").css("strong").text
      # original_price = doc.css("#flash_deal_goods_list").css(".price_info").css(".price").css("del").text
      # discount = doc.css("#flash_deal_goods_list").css(".price_info").css(".sale").text
#         
      # rear_link_url = doc.css("#flash_deal_goods_list").css(".tag")[0].attributes["href"].value
      # tmp_ary = rear_link_url.split("/")
      # event_id = tmp_ary[-1]
      # event_name = "[g9 FLASH DEAL]" + title
      # event_url = url + rear_link_url
      # event = Event.where(event_id: event_id, event_site_id: event_site_id)
      # image_url = doc.css("#flash_deal_goods_list").css(".thumbnail")[0].attributes["src"].value
      # if event.blank?
        # Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, 
                      # price: price, original_price: original_price, discount: discount, show_flg: true, push_flg: true, update_flg: true)
        # event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
        # event_ary.push event_hash
      # end
      # event_ary
    # rescue => e
      # p e.backtrace
      # return event_ary = []
    # end
  # end
  
  # move => event_alram_mailer_watir
  # def self.megabox
    # url = "http://www.megabox.co.kr/?menuId=store"
    # event_site_id = 4003
#     
    # browser = Watir::Browser.new
      # browser.goto(url)
      # while browser.div(:id=>"bestDealLoding").visible? do sleep 1 end
      # doc = Nokogiri::HTML.parse(browser.html)
      # browser.close
      # lis = doc.css(".store_lst").css("li")
#       
      # lis.each do |li|
        # event_id = li.css(".blank").attr("data-code").value
        # event = Event.where(event_id: event_id, event_site_id: event_site_id)
        # if event.blank?
          # title = li.css("h5").text
          # price = li.css("b")[0].text
          # price.lstrip!
          # original_price = li.css("s").text
          # event_name = "[메가박스]" + title 
          # event_url = url
          # image_url = li.css(".img_pro").attr("src").value
#         
          # if title.include?("1+1")
            # Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price, 
                            # show_flg: true, push_flg: true, update_flg: true)
          # else
            # Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price)
          # end
          # event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
          # event_ary.push event_hash
        # end
      # end
      # event_ary
  # end
  
  def self.check_event_data(browser)
    begin
      g9s = Event.where(event_site_id: 1003)
      g9s.each_with_index do |g9, i|
        begin
          browser.goto g9.event_url
          browser.div(:class => 'vip_v3_thumb').wait_until_present
          doc = Nokogiri::HTML.parse(browser.html)
          if doc.css("#spSoldOutText").attr("style").value.include?("none")
            g9.update(show_flg: true) if g9.show_flg == false
          else
            g9.update(show_flg: false) if g9.show_flg == true
          end
          p "total #{i+1}/#{g9s.size}"
        rescue => e
          p e.backtrace
          p "error #{g9.id}"
          next
        end
      end
      return true
    rescue
      return false
    end
  end
  
end
