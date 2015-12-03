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
  
end