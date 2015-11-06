#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

    # url = "http://www.cgv.co.kr/culture-event/event/?menu=2#1"
    # html_str = open(url).read
#     
    # doc = Nokogiri::HTML(html_str)
#     
    # script = doc.search("script").to_s
    # script_ary = script.split(';')
    # event_data = ""
    # script_ary.each do |s|
      # if s.include?('cgv.co.kr/Event/Event')
        # event_data = s
      # end
    # end
    # event_data.strip!
    # event_ary = event_data.split('[')
    # event_str = "[" + event_ary[1]
#     
    # event_ary = JSON.parse(event_str)
#     
    # new_event = []
#     
    # event_ary.each do |event|
      # cgv_event = CgvEvent.find_by_event_id(event["idx"])
      # unless cgv_event
        # new_event.push event
        # CgvEvent.create(event_id: event["idx"])
      # end
    # end
    # NoticeMailer.sendmail_confirm.deliver unless new_event.blank?
    NoticeMailer.sendmail_confirm.deliver