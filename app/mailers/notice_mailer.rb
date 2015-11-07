# coding : utf-8
require 'open-uri'
class NoticeMailer < ActionMailer::Base
  #デフォルトのヘッダ情報
  # default to: Proc.new { ["tellus.event@gmail.com", "goodnews1079@gmail.com"] }, from: 'shimtong1004@gmail.com'
  default to: Proc.new { ["tellus.event@gmail.com"] }, from: 'shimtong1004@gmail.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.sendmail_confirm.subject
  #
  def sendmail_confirm
    # @event_ary = CgvEvent.find_by_is_send(false)
    # @first_url = "http://www.cgv.co.kr/culture-event/event/"
    
    @first_url = "http://www.cgv.co.kr/culture-event/event/"
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
      cgv_event = CgvEvent.find_by_event_id(event["idx"])
      unless cgv_event
        new_event.push event
        CgvEvent.create(event_id: event["idx"])
      end
    end
    @event_ary = new_event
    return if @event_ary.blank?
    
    mail subject: "이벤트 알림"
  end
  
  def lotteciname_sendmail_confirm    
    @first_url = "http://www.lottecinema.co.kr"
    @link_url = "http://www.lottecinema.co.kr/LHS/LHFS/Contents/Event/LotteCinemaEventView.aspx?eventId="
    url = "http://www.lottecinema.co.kr/LHS/LHFS/Contents/Event/MovieEventMain.aspx"
    html_str = open(url).read
    
    doc = Nokogiri::HTML(html_str)
    
    ul = doc.search("ul.lcevent_list")[0]
    lis = ul.search("li")
    
    @event_ary = []
    lis.each do |li|
      event_id = li.css("a")[0].attributes["href"].value.split("(")[1].split(",")[0].gsub('"', '').to_i
      event_name = li.css("dl dt a")[0].children[1].text
      event_url = @link_url + event_id.to_s
      lotte_cinema = LottecinemaEvent.find_by_event_id(event_id)
      unless lotte_cinema
        LottecinemaEvent.create(event_id: event_id, event_name: event_name, event_url: event_url)
        event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
        @event_ary.push event_hash
      end
    end
    
    return if @event_ary.blank?
    
    mail subject: "롯데시네마 이벤트 알림"
  end
  
  def clien_frugal_buy_sendmail_confirm
    @title = "클리앙 이벤트 알림"
    @first_url = "http://m.clien.net/cs3/board"
    url = "http://m.clien.net/cs3/board?bo_style=lists&bo_table=jirum"
    html_str = open(url).read
    
    doc = Nokogiri::HTML(html_str)
    
    divs = doc.css("div.wrap_tit")
    
    @event_ary = []
    divs.each do |div|
      if div.attributes["onclick"]
        event_id = div.attributes["onclick"].value.split('&')[2]
        event_id.slice! "wr_id="
        event_name = div.css("span.lst_tit").text
        event_url = @first_url + div.attributes["onclick"].value.split("'")[1]
        
        clien_fruga_event = ClienFrugalEvent.find_by_event_id(event_id)
        
        unless clien_fruga_event
          ClienFrugalEvent.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url)
          event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
          @event_ary.push event_hash
        end
      end
    end
    return if @event_ary.blank?
    
    mail subject: @title
  end
  
end