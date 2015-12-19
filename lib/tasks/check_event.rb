#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

#deal_item데이터를 필터해서 event에 추가함.
    begin
      # ids = [1001, 1002, 1003, 1005, 9001]
      ids = [1001, 1002, 1005, 9001]
      datas = Event.where(event_site_id: ids, show_flg: true).order("id")
      datas.each_with_index do |data, i|
        begin
          html_str = open(data.event_url).read
          # browser.goto data.event_url
          flg = true
          
          if data.event_site_id == 1001
            doc = Nokogiri::HTML(html_str)
            flg = false if doc.css(".btn_buy_end").text == "판매완료"
          elsif data.event_site_id == 1002
            doc = Nokogiri::HTML(html_str)
            flg = false if doc.css("#orderButton").text == "판매종료"
            
          elsif data.event_site_id == 1005
            doc = Nokogiri::HTML(html_str)
            flg = false if doc.css("#buy_button").text == "판매종료" || doc.css(".no_find").text.include?("상품을 찾을 수 없습니다")
          elsif data.event_site_id == 9001
            doc = Nokogiri::HTML(html_str)
            flg = false if doc.css("#btn_buy").text == "매진"         
          end
          
          if flg
            data.update(show_flg: true) if data.show_flg == false
          else
            data.update(show_flg: false) if data.show_flg == true
          end
          p "total #{i+1}/#{datas.size}"
        rescue => e
          p e.backtrace
          p "error #{data.id}"
          next
        end
      end
    rescue
      p e.backtrace
    end