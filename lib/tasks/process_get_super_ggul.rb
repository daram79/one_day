#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"
path = "#{File.dirname(__FILE__)}/../../"
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
          open("#{File.dirname(__FILE__)}/../../public/image/super_ggul_b.jpg", 'wb') do |file|
            file << open(image_url).read
          end
          a_path = "#{path}public/image/super_ggul_a.jpg"
          b_path = "#{path}public/image/super_ggul_b.jpg"
          mask_path = "#{path}public/image/super_ggul_mask.png"
          ret = Event.is_same?(a_path, b_path, mask_path)
          if ret
            Event.create(event_id: event_id, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                          image_url: image_url, price: price, original_price: original_price, discount: discount, show_flg: true, push_flg: true, update_flg: true)
          end
        end
      end
    rescue => e
      pp e.backtrace
    end