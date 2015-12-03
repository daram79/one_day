# coding : utf-8
require 'open-uri'
class MovieAlramMailer < ActionMailer::Base
  default :from => "shimtong1004@gmail.com"
  #デフォルトのヘッダ情報
  # default to: Proc.new { EventMailingList.where(send_flg: true).pluck(:email) }, from: 'shimtong1004@gmail.com'
  # default to: Proc.new { ["tellus.event@gmail.com"] }, from: 'shimtong1004@gmail.com'
  
  
  # 1.정해진 사이트에 가서 항공권 데이터를 가지고 옮
  # 2.가지고 온 데이터중 항공권데이터만 사용
  # 3.항공권 데이터에서 필요한 정보(가격...)들을 추출한다.
  # 4.추출한 가격과 기준 가격을 비교해서 가지고 온 데이터의 가격이 낮으면 오픈 그렇지 않으면 저장만 함.
  
  def movie_event_cgv
    begin
      @title = "[CGV 1+1]"
      first_url = "http://www.cgv.co.kr/culture-event/event/"
      url = "http://www.cgv.co.kr/culture-event/event/?menu=2#1"
      event_site_id = 4001
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
      tmp = event_data.split('[')
      event_str = "[" + tmp[1]
      
      json_event_ary = JSON.parse(event_str)
      @event_ary = []
      
      json_event_ary.each do |event|
        db_event = Event.where(event_id: event["idx"], event_site_id: event_site_id)
        if db_event.blank?
          event_hash = {event_id: event["idx"], event_name: event["description"], event_url: first_url + event["link"]}
          @event_ary.push event_hash
          if event["description"].include?("1+1")
            Event.create(event_id: event["idx"], event_name: event["description"], event_site_id: event_site_id, event_url: first_url + event["link"], show_flg: true, push_flg: true, update_flg: true)
          else
            Event.create(event_id: event["idx"], event_name: event["description"], event_site_id: event_site_id, event_url: first_url + event["link"])
          end
        end
      end
      email = EventMailingList.all.pluck(:email)
      return if @event_ary.blank? || email.blank?
      mail to: email , subject: @title
    rescue => e
      p e.backtrace
      @title = "CGV error"
      @event_ary = []
      @event_ary.push "app/mailers/movie_alram_mailer.rb"
      @err_msg = e.backtrace
      mail to: "shimtong1004@gmail.com" , subject: @title
      # render "event_mailer"
      #send error mail
    end
  end
  
  def movie_event_lotteciname
    begin
      @title = "롯데시네마 1+1"
      link_url = "http://www.lottecinema.co.kr/LHS/LHFS/Contents/Event/LotteCinemaEventView.aspx?eventId="
      url = "http://www.lottecinema.co.kr/LHS/LHFS/Contents/Event/MovieEventMain.aspx"
      event_site_id = 4002
      
      html_str = open(url).read
      
      doc = Nokogiri::HTML(html_str)
      
      ul = doc.search("ul.lcevent_list")[0]
      lis = ul.search("li")
      
      @event_ary = []
      lis.each do |li|
        event_id = li.css("a")[0].attributes["href"].value.split("(")[1].split(",")[0].gsub('"', '').to_i
        event_name = li.css("dl dt a")[0].children[1].text
        event_url = link_url + event_id.to_s
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        if event.blank?
          if event_name.include?("1+1")
            Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id, show_flg: true, push_flg: true, update_flg: true)
          else
            Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id)
          end
          event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
          @event_ary.push event_hash
        end
      end
      
      email = EventMailingList.all.pluck(:email)
      return if @event_ary.blank? || email.blank?
      mail to: email , subject: @title
    rescue => e
      p e.backtrace
      @title = "롯데시네마 error"
      @event_ary = []
      @event_ary.push "app/mailers/movie_alram_mailer.rb"
      @err_msg = e.backtrace
      mail to: "shimtong1004@gmail.com" , subject: @title
      # render "event_mailer"
      #send error mail
    end
  end
  
end