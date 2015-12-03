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
  
  
  def self.get_cgv_data(event_site_id)
    begin
      first_url = "http://www.cgv.co.kr/culture-event/event/"
      url = "http://www.cgv.co.kr/culture-event/event/?menu=2#1"
      html_str = open(url).read
      
      doc = Nokogiri::HTML(html_str)
      
      script = doc.search("script").to_s
      script_ary = script.split(';')
      event_data = ""
      script_ary.each do |s|
        if s.include?('cgv.co.kr/Event/Event')
          event_data = s
        end
      end
      event_data.strip!
      event_ary = event_data.split('[')
      event_str = "[" + event_ary[1]
      
      event_ary = JSON.parse(event_str)
      new_event = []
      
      event_ary.each do |event|
        db_event = Event.where(event_id: event["idx"], event_site_id: event_site_id)
        if db_event.blank?
          event_hash = {event_id: event["idx"], event_name: event["description"], event_url: first_url + event["link"]}
          new_event.push event_hash
          Event.create(event_id: event["idx"], event_name: event["description"], event_site_id: event_site_id, event_url: first_url + event["link"])
        end
      end
      new_event
    rescue => e
      p e.backtrace
      return new_event = []
    end
  end
  
  def self.get_lotteciname_data(event_site_id)
    begin
      link_url = "http://www.lottecinema.co.kr/LHS/LHFS/Contents/Event/LotteCinemaEventView.aspx?eventId="
      url = "http://www.lottecinema.co.kr/LHS/LHFS/Contents/Event/MovieEventMain.aspx"
      html_str = open(url).read
      
      doc = Nokogiri::HTML(html_str)
      
      ul = doc.search("ul.lcevent_list")[0]
      lis = ul.search("li")
      
      event_ary = []
      lis.each do |li|
        event_id = li.css("a")[0].attributes["href"].value.split("(")[1].split(",")[0].gsub('"', '').to_i
        event_name = li.css("dl dt a")[0].children[1].text
        event_url = link_url + event_id.to_s
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        if event.blank?
          Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id)
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
      first_url = "http://m.ticketmonster.co.kr"
      url = "http://m.ticketmonster.co.kr/deal?cat=20070759"
      html_str = open(url).read
      doc = Nokogiri::HTML(html_str)
      # lis = doc.search(".prd_wrap li")
      
      event_ary = []
      # lis.each do |li|
      title = doc.css(".lst_dl")[0].css(".info")[0].css(".tit").text
        
      price = doc.css(".lst_dl")[0].css(".info")[0].css(".price")[0].css(".won")[0].css(".sale").text
      original_price = doc.css(".lst_dl")[0].css(".info")[0].css(".price")[0].css(".won")[0].css(".org").text
      discount = doc.css(".lst_dl")[0].css(".info")[0].css(".price")[0].css(".per").text
        
      rear_link_url = doc.css(".lst_dl")[0].css("a")[0].attributes["href"].value
        
      event_id = rear_link_url.split("/")[3].split("?")[0]
      event_name = "[티몬 슈퍼꿀딜]" + title
      event_url = first_url + rear_link_url
      event = Event.where(event_id: event_id, event_site_id: event_site_id)
      image_url = doc.css(".lst_dl")[0].css(".thm")[0].css("img")[0].attributes["src"].value
      if event.blank?
        Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price, discount: discount)
        event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
        event_ary.push event_hash
      end
      # end
      event_ary
    rescue => e
      p e.backtrace
      return event_ary = []
    end
  end
  
  def self.get_g9_flash_deal(event_site_id)
    begin
      url = "http://www.g9.co.kr"
      browser = Watir::Browser.new
      browser.goto(url)
      while browser.div(:id=>"bestDealLoding").visible? do sleep 1 end
      browser.execute_script("window.scrollTo(0, document.body.scrollHeight);\n")
      doc = Nokogiri::HTML.parse(browser.html)
      browser.close
      event_ary = []
      title = doc.css("#flash_deal_goods_list").css(".title").text.delete!("\n").delete!("\t")
      price = doc.css("#flash_deal_goods_list").css(".price_info").css(".price").css("strong").text
      original_price = doc.css("#flash_deal_goods_list").css(".price_info").css(".price").css("del").text
      discount = doc.css("#flash_deal_goods_list").css(".price_info").css(".sale").text
        
      rear_link_url = doc.css("#flash_deal_goods_list").css(".tag")[0].attributes["href"].value
      tmp_ary = rear_link_url.split("/")
      event_id = tmp_ary[-1]
      event_name = "[g9 FLASH DEAL]" + title
      event_url = url + rear_link_url
      event = Event.where(event_id: event_id, event_site_id: event_site_id)
      image_url = doc.css("#flash_deal_goods_list").css(".thumbnail")[0].attributes["src"].value
      if event.blank?
        Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price, discount: discount)
        event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
        event_ary.push event_hash
      end
      event_ary
    rescue => e
      p e.backtrace
      return event_ary = []
    end
  end
  
  def self.aaa
    first_url = "http://www.g9.co.kr"
    url = "http://www.g9.co.kr/Display/TodaysDeal/TodaysDeal"
    browser = Watir::Browser.new
      browser.goto(url)
      while browser.div(:id=>"bestDealLoding").visible? do sleep 1 end
      # browser.execute_script("window.scrollTo(0, document.body.scrollHeight);\n")
      doc = Nokogiri::HTML.parse(browser.html)
      browser.close
      datas = doc.css(".date_counter")
      
      datas.each do |data|
        title = data.css(".title").text
        
        price = data.css(".price").css("em").text + " " + data.css(".price").css("strong").text
        price.lstrip!
        original_price = data.css(".price").css("del").text
        discount = data.css(".price_info").css(".sale").text
        
        rear_url = data.css(".tag").attr("href").value
        event_id = data.css(".tag").attr("href").value.split("/")[-1]
        event_name = "[G9 베스트]" + title   
        event_url = first_url + rear_url
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        image_url = data.css(".thumbs").css("img").attr('src').value
        if event.blank?
          Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price, discount: discount)
          event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
          event_ary.push event_hash
        end
      end
      event_ary
      
  end
  
end
