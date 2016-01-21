# coding : utf-8
require 'open-uri'
class Event < ActiveRecord::Base
  
  after_create :send_push
  after_update :send_push
  
  @@super_deal_ids = ["9001", "9002", "4001", "4002", "4003", "9900"]
=begin  
  def send_push
    if self.push_flg && self.show_flg
      if @@super_deal_ids.any? { |id| self.event_site_id.to_s.include?(id) }
        #꿀딜, 플레쉬딜 영화 1+1 알림
        Thread.new do
          gcm = GCM.new("AIzaSyD_3jJfuO8NT8G-kDHcmTiwl3w0W1JuxXQ")
          # user_ids = EventMailingList.all.ids
          option = { :data => {'message' => self.event_name + "***" + self.event_url} }
          # registration_ids = EventUserRegistrations.where(event_user_id: user_ids).pluck(:registration_id)
          registration_ids = EventUserRegistrations.all.pluck(:registration_id)
          gcm.send(registration_ids, option) unless registration_ids.blank?
        end
      else
        #이벤트 알림
      end
    end
  end
=end

  def send_push
    if self.push_flg && self.show_flg
      logger.info("called send_push")
      if @@super_deal_ids.any? { |id| self.event_site_id.to_s.include?(id) }
        logger.info("call send_push_button")
        Event.send_push_button(self)
      end
    end
  end
  
  def self.send_push_button(e)
    
    gcm = GCM.new("AIzaSyD_3jJfuO8NT8G-kDHcmTiwl3w0W1JuxXQ")
    price = e.price.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,') + "원 - "
    price = "" if price == "0원 - " || price == "원 - "
    option = { :data => {'message' => "#{price}#{e.event_name} " + "***" + e.event_url} }
    registration_ids = EventUserRegistrations.all.pluck(:registration_id)
    registration_ids.uniq!
    unless registration_ids.blank?
      response = gcm.send(registration_ids, option)
      self.send_push_check_button(response, registration_ids)
    end
  end
  
  def self.send_push_check_button(response, registration_ids)
    loop_flg = true
    loop_flg = false if JSON.parse(response[:body])["failure"] == 0
    while loop_flg
      rr = JSON.parse(response[:body])["results"]
      
      delete_ids = response[:not_registered_ids]
      update_ids = []
      success_ids = []
      
      rr.each_with_index do |r, i|
        update_hash = Hash.new
        if r.key?("error") && r.value?("NotRegistered")
          # delete_ids.push registration_ids[i]
        elsif r.key?("error") && r.value?("InvalidRegistration")
          # delete_id_index.push i
          delete_ids.push registration_ids[i]
        elsif r.key?("message_id") && r.key?("registration_id")
          update_hash[:old] = registration_ids[i]
          update_hash[:new] = r["registration_id"]
          update_ids.push(update_hash)
          # delete_id_index.push i
        elsif r.key?("error") && r.value?("Unavailable")
          #전송 실패한 아이디는 다시 전송
        elsif r.key?("message_id") && r.size == 1
          success_ids.push registration_ids[i]
          # update_id_index.push i
        end
      end
          
      #푸쉬에 성공한 registration_id 배열에서 삭제함.
      success_ids.each do |success_id|
        i = registration_ids.index(success_id)
        registration_ids.delete_at(i)
      end
      
      
      #잘못된 registration_id 배열에서 삭제
      del_event_registrations = EventUserRegistrations.where(registration_id: delete_ids)
      del_event_registrations.destroy_all
      
      #잘못된 registration_id DB에서 삭제
      delete_ids.each do |del_id|
        i = registration_ids.index(del_id)
        registration_ids.delete_at(i)
      end
      
      #변경된 registration_id 배열/DB에서 업데이트
      update_ids.each do |up_id|
        i = registration_ids.index(up_id[:old])
        registration_ids[i] = up_id[:new]
        up_event_registrations = EventUserRegistrations.find_by_registration_id(up_id[:old])
        up_event_registrations.update(registration_id: up_id[:new])
      end
      unless registration_ids.blank?
        response, registration_ids = self.re_send_push_button(registration_ids)
        loop_flg = false if JSON.parse(response[:body])["failure"] == 0
      else
        loop_flg = false
      end
      
    end  
  end
  
  def self.re_send_push_button(registration_ids)
    gcm = GCM.new("AIzaSyD_3jJfuO8NT8G-kDHcmTiwl3w0W1JuxXQ")
    option = { :data => {'message' => self.event_name + "***" + self.event_url} }
    registration_ids = EventUserRegistrations.all.pluck(:registration_id)
    unless registration_ids.blank?
      response = gcm.send(registration_ids, option)
      return response, registration_ids
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
            Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id)
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
            Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id)
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
              Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id)
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
        price = price.scan(/\d/).join('').to_i
        original_price = ary_price[2] ? ary_price[1].strip! : ""
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        if event.blank?
          Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price)
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
        price = price.scan(/\d/).join('').to_i
        original_price = li.css(".price_wrap s").text
        discount = li.css(".sale").text
        
        event_id = li.attributes["prdno"].value
        event_name = "[11번가 쇼킹딜]" + title
        event_url = li.css("a")[0].attributes["href"].value if li.css("a")[0].attributes["href"]
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        image_url = li.css(".thumb_prd").css("img")[0].attributes["src"].value
        if event.blank?
          Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price, discount: discount)
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
        price = price.scan(/\d/).join('').to_i
        original_price = li.css(".price_wrap s").text
        discount = li.css(".sale").text
        
        event_id = li.attributes["prdno"].value
        event_name = "[11번가 쇼킹딜]" + title
        event_url = li.css("a")[0].attributes["href"].value if li.css("a")[0].attributes["href"]
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        image_url = li.css(".thumb_prd").css("img")[0].attributes["src"].value
        if event.blank?
          Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price, discount: discount)
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
      # url = "http://m.ticketmonster.co.kr/deal?cat=20070759"
      url = "http://m.ticketmonster.co.kr/"
      
      html_str = open(url).read
      doc = Nokogiri::HTML(html_str)
      
      event_ary = []
      lis = doc.css("#flick_lst li")
      lis.each do |li|
        title = li.css(".thmb img").attr("alt").value
        if title.include?("슈퍼") && title.include?("꿀딜")
          price = li.css(".sale em").text
          price = price.scan(/\d/).join('').to_i
          original_price = li.css(".prime em").text
          discount = ""
          rear_link_url = li.css("a")[0].attributes["href"].value
          event_id = rear_link_url.split("/")[3].split("?")[0]
          event_name = title
          event_url = first_url + rear_link_url
          event = Event.where(event_id: event_id, event_site_id: event_site_id)
          image_url = li.css(".thmb img").attr("src").value
          if event.blank?
            Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price, discount: discount, show_flg: true, push_flg: true, update_flg: true)
            event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
            event_ary.push event_hash
          end
        end
      end
      event_ary
      
      
      # event_ary = []
      # title = doc.css(".lst_dl")[0].css(".info")[0].css(".tit").text
      # if title.include?("슈퍼") && title.include?("꿀딜")
        # price = doc.css(".lst_dl")[0].css(".info")[0].css(".price")[0].css(".won")[0].css(".sale").text
        # price = price.scan(/\d/).join('').to_i
        # original_price = doc.css(".lst_dl")[0].css(".info")[0].css(".price")[0].css(".won")[0].css(".org").text
        # discount = doc.css(".lst_dl")[0].css(".info")[0].css(".price")[0].css(".per").text
#           
        # rear_link_url = doc.css(".lst_dl")[0].css("a")[0].attributes["href"].value
#           
        # event_id = rear_link_url.split("/")[3].split("?")[0]
        # event_name = title
        # event_url = first_url + rear_link_url
        # event = Event.where(event_id: event_id, event_site_id: event_site_id)
        # image_url = doc.css(".lst_dl")[0].css(".thm")[0].css("img")[0].attributes["src"].value
        # if event.blank?
          # Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, 
                          # price: price, original_price: original_price, discount: discount, show_flg: true, push_flg: true, update_flg: true)
          # event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
          # event_ary.push event_hash
        # end
      # end
      # event_ary
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
        # Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, 
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
            # Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price, 
                            # show_flg: true, push_flg: true, update_flg: true)
          # else
            # Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price)
          # end
          # event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
          # event_ary.push event_hash
        # end
      # end
      # event_ary
  # end
  
  def self.check_event_data(browser)
    begin
      ids = [1003]
      datas = Event.where(event_site_id: ids, show_flg: true).order("id")
      datas.each_with_index do |data, i|
        begin
          browser.goto data.event_url
          flg = true
          if data.event_site_id == 1003
            browser.div(:class => 'vip_v3_thumb').wait_until_present
            doc = Nokogiri::HTML.parse(browser.html)
            flg = false unless doc.css("#spSoldOutText").attr("style").value.include?("none")
          elsif data.event_site_id == 1001
            begin
              browser.link(:onclick=>"close_regpop();").click
            rescue
            end
            doc = Nokogiri::HTML.parse(browser.html)
            flg = false if doc.css(".btn_buy_end").text == "판매완료"
          elsif data.event_site_id == 1002
            doc = Nokogiri::HTML.parse(browser.html)
            flg = false if doc.css("#orderButton").text == "판매종료"
          elsif data.event_site_id == 9001
            doc = Nokogiri::HTML.parse(browser.html)
            flg = false if doc.css("#btn_buy").text == "매진"
          elsif data.event_site_id == 1005
            begin
              browser.link(:onclick=>"hideSubscribe();return false;").click
            rescue
            end
            doc = Nokogiri::HTML.parse(browser.html)
            flg = false if doc.css("#buy_button").text == "판매종료" || doc.css(".no_find").text.include?("상품을 찾을 수 없습니다")
          else
            next
          end
          
          if flg
            data.update(show_flg: true) if data.show_flg == false
          else
            data.update(show_flg: false) if data.show_flg == true
          end
          p "total #{i+1}/#{datas.size}"
        rescue => e
          pp e.backtrace
          p "error #{data.id}"
          next
        end
      end      
      return true
    rescue
      return false
    end
  end
  
end
