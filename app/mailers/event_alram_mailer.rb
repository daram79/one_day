# coding : utf-8
require 'open-uri'
class EventAlramMailer < ActionMailer::Base
  default :from => "shimtong1004@gmail.com"
  #デフォルトのヘッダ情報
  # default to: Proc.new { EventMailingList.where(send_flg: true).pluck(:email) }, from: 'shimtong1004@gmail.com'
  # default to: Proc.new { ["tellus.event@gmail.com"] }, from: 'shimtong1004@gmail.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.sendmail_confirm.subject
  #
  def start_bugs_sendmail_confirm()
  end
  
  
  # 1.정해진 사이트에 가서 항공권 데이터를 가지고 옮
  # 2.가지고 온 데이터중 항공권데이터만 사용
  # 3.항공권 데이터에서 필요한 정보(가격...)들을 추출한다.
  # 4.추출한 가격과 기준 가격을 비교해서 가지고 온 데이터의 가격이 낮으면 오픈 그렇지 않으면 저장만 함.
  
  def airticket_tmon
    begin
      @title = "티몬 항공권 알림"
      event_site_id = 2001
      front_url = "http://www.ticketmonster.co.kr"
      type = "항공권"
      url = "http://www.ticketmonster.co.kr/home"
      
      html_str = open(url).read
      doc = Nokogiri::HTML(html_str)
      sliders = doc.search(".slider_item")
      @event_ary = []
      sliders.each do |slider|
        title = slider.search(".tit").text
        if title.include?(type)
          rear_url = slider.css("a")[0].attributes["href"].value
          event_id = rear_url.split("/")[2]
          event = Event.where(event_id: event_id, event_site_id: event_site_id)
          if event.blank?
            ary_price = slider.css(".price").text.split("\n")
            event_name = "[티몬]" + title
            event_url = front_url + rear_url
            image_url = slider.css(".thum").css("img")[0].attributes["src"].value
            price = ary_price[0]
            original_price = ary_price[2] ? ary_price[1].strip! : ""
            
            #항공권이 10,000원 이하면 바로 푸시
            if price.scan(/\d/).join('').to_i < 10000
              Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                            image_url: image_url, price: price, original_price: original_price, show_flg: true, push_flg: true, update_flg: true)
            elsif ['일본','동경', '오사카', '나고야', '후쿠오카', '중국', '북경', '베이징', '상해', '상하이', '홍콩', '싱가폴', '필리핀', '베트남'].any? { |word| title.include?(word) } && price.scan(/\d/).join('').to_i < 150000
              Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                            image_url: image_url, price: price, original_price: original_price, show_flg: true, push_flg: true, update_flg: true)
            else
              Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                            image_url: image_url, price: price, original_price: original_price)
            end
            
            # ['alo','hola','test'].any? { |word| str.include?(word) } #문자에 배열중에 같은 값을 포하고 있는지 비교
            # a.scan(/\d/).join('')  #문자&숫자에서 숫자만 가져옴
            
            
            event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
            @event_ary.push event_hash
          end
        end
      end
      email = EventMailingList.all.pluck(:email)
      return if @event_ary.blank? || email.blank?
      mail to: email , subject: @title
      
    rescue => e
      p e.backtrace
      @title = "티몬 항공권 error"
      @event_ary = []
      @event_ary.push "app/mailers/event_alram.rb"
      @err_msg = e.backtrace
      mail to: "shimtong1004@gmail.com" , subject: @title
      #send error mail
    end
  end
  
  
  def conveni_event_gs25
    begin
      @title = "편의점 알림"
      event_site_id = 3001
      front_url = "http://gs25.gsretail.com/"
      type = "편의점"
      url = "http://gs25.gsretail.com/gscvs/ko/customer-engagement/event/current-events"
      browser = Watir::Browser.new
      browser.goto(url)
      doc = Nokogiri::HTML.parse(browser.html)
      browser.close
      
      trs = doc.css(".tbl_ltype1").css("tbody").css("tr")
      
      @event_ary = []
      trs.each do |tr|
        title = "[" + tr.css(".evt_info").css(".evt_type").text + "]" +
                  tr.css(".evt_info").css(".tit").text +
                  tr.css(".evt_info").css(".period").text
        rear_url = tr.css("a").attr("href").value
        event_id = rear_url.split("/")[-1].split("=")[-1]
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        if event.blank?
          event_name = title
          event_url = front_url + rear_url
          image_url = tr.css("img").attr("src").value
          
          Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url)
            
            
          event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
          @event_ary.push event_hash
        end
      end
      email = EventMailingList.all.pluck(:email)
      return if @event_ary.blank? || email.blank?
      mail to: email , subject: @title
      
    rescue => e
      p e.backtrace
      @title = "GS25 이벤트 error"
      @event_ary = []
      @event_ary.push "app/mailers/event_alram.rb"
      @err_msg = e.backtrace
      mail to: "shimtong1004@gmail.com" , subject: @title
      #send error mail
    end
  end
  
  def conveni_event_ministop
    event_site_id = 3002
  end
  
  def conveni_event_cu
    begin
      url = "http://membership.bgfretail.com/event/event/list.do?viewDiv=1"
      @title = "편의점 알림"
      event_site_id = 3003
      front_url = "http://membership.bgfretail.com/"
      type = "편의점"
      
      html_str = open(url).read
      doc = Nokogiri::HTML(html_str)
      trs = doc.css(".list_style01").css("tbody").css("tr")
      @event_ary = []
      trs.each do |tr|
        event_status = tr.css(".ing_ev").css("img").attr("alt").value
        if event_status.include?("진행")
          event_id = tr.css("td")[0].text
          event = Event.where(event_id: event_id, event_site_id: event_site_id)
          if event.blank?
            title = tr.css(".txt").text
            rear_url = tr.css(".img").attr("href").value
            event_name = "[CU]" + title
            event_url = front_url + rear_url
            image_url = tr.css("img").attr("src").value
              
            Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                            image_url: image_url)
            event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
            @event_ary.push event_hash
          end
        end
      end
      email = EventMailingList.all.pluck(:email)
      return if @event_ary.blank? || email.blank?
      mail to: email , subject: @title
      render "event_mailer"
      
    rescue => e
      p e.backtrace
      @title = "CU error"
      @event_ary = []
      @event_ary.push "app/mailers/event_alram.rb"
      @err_msg = e.backtrace
      mail to: "shimtong1004@gmail.com" , subject: @title
      render "event_mailer"
      #send error mail
    end
    
  end
  
end