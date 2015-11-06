# coding : utf-8
require 'open-uri'
class NoticeMailer < ActionMailer::Base
  #デフォルトのヘッダ情報
  # default to: Proc.new { ["shimtong1004@gmail.com", "goodnews1079@gmail.com"] }, from: 'shimtong1004@gmail.com'
  default to: Proc.new { ["shimtong1004@gmail.com"] }, from: 'shimtong1004@gmail.com'

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
end