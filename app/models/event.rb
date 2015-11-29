# coding : utf-8
require 'open-uri'
class Event < ActiveRecord::Base
  
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
    rescue
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
    rescue
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
    rescue
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
    rescue
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
    rescue
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
    rescue
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
        if ary_price.size > 2
          event_name = "[티켓 몬스터]" + title + " " + ary_price[2].strip! + " => " + ary_price[0]
        else
          event_name = "[티켓 몬스터]" + title + " " + ary_price[0] 
        end
        
        link_url = slider.css("a")[0].attributes["href"].value
        event_url = first_url + link_url
        event_id = link_url.split("/")[2]
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        if event.blank?
          Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id)
          event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
          event_ary.push event_hash
        end
      end
      event_ary
    rescue
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
        discount = li.css(".sale").text
        
        event_id = li.attributes["prdno"].value
        event_name = "[11번가 쇼킹딜]" + title + " " + discount + " " + price
        event_url = li.css("a")[0].attributes["href"].value
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        if event.blank?
          Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id)
          event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
          event_ary.push event_hash
        end
      end
      event_ary
    rescue
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
        discount = li.css(".sale").text
        
        event_id = li.attributes["prdno"].value
        event_name = "[11번가 쇼킹딜]" + title + " " + discount + " " + price
        event_url = li.css("a")[0].attributes["href"].value
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        if event.blank?
          Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id)
          event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
          event_ary.push event_hash
        end
      end
      event_ary
    rescue
      return event_ary = []
    end
  end
  
end
