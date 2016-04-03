#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"


    url = "http://www.sangmuya.com/"
    html_str = open(url).read
    doc = Nokogiri::HTML(html_str)
    
    # data = doc.css(".event .item .image")
    data = doc.css(".event .item")
    
    
    
    
    event_id = data.css(".image img").attr("src").value.split("/")[-1].split(".")[0]
    event_name = "유상무 잘생겼다 이벤트"
    image_url = url + doc.css(".event .item .image img").attr("src").value
    event_url = url + doc.css(".des .btn_go a").attr("href").value
    
    event = Event.where(event_id: event_id)
    
    Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: 9999, show_flg: true, push_flg: true, update_flg: true, image_url: image_url) if event.blank?
      