# coding : utf-8
require 'open-uri'
class EventAlramMailerWatir < ActionMailer::Base
  default :from => "shimtong1004@gmail.com"
  
  def airticket_coocha(doc, site_id)
    begin
      @title = "항공권 알림"
      event_site_id = site_id
      type = "항공권"
      
      hot_clicks = doc.css("#section_hotclick").css(".list-item")
      @event_ary = []
      unless hot_clicks.blank?
        hot_clicks.each do |hot|
          original_site = hot.css(".areas").css(".area-info").text.delete!("\n").delete!("\t").strip!
          title = hot.css(".areas").css(".area-title").text
          if title.include?(type)
            rear_url = ""
            event_id = hot.attr("data-did")
            event = Event.where(event_id: event_id, event_site_id: event_site_id)
            event_name = "[" + hot.css(".areas").css(".area-info").text.delete!("\n").delete!("\t").strip! + "]" +  title
            if event.blank?
              if "위메프".eql?(original_site)
                event_url = "http://www.wemakeprice.com/search?search_keyword=" + title
              elsif "티몬".eql?(original_site)
                event_url = "http://www.wemakeprice.com/search?search_keyword=" + title.split('/')[0]
              elsif "쿠팡".eql?(original_site)
                event_url = "http://m.coupang.com/np/search?q=" + title
                # event_url = "http://www.coupang.com/np/search?q=" + title
              elsif "G마켓".eql?(original_site)
                event_url = "http://gtour.gmarket.co.kr/TourLP/Search?selecturl=total&keyword=" + title
              elsif "옥션 올킬".eql?(original_site)
                event_url = "http://stores.auction.co.kr/mrtour/List?keyword=" + title
              elsif "여행박사".eql?(original_site)
                event_url = ""
              else
                event_url = ""
              end
              
              image_url = hot.css("img").attr("src").value
              price = hot.css(".areas").css(".price-custom").text.delete!("\n").delete!("\t").strip!
              original_price = hot.css(".areas").css(".price-origin").text.delete!("\n").delete!("\t").strip!
              
              #항공권이 15,000원 이하면 바로 푸시
              if title.include?("오사카")
                if price.scan(/\d/).join('').to_i < 150000
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price, show_flg: true, push_flg: true, update_flg: true)
                else
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price)
                end
              elsif title.include?("동경") || title.include?("도쿄")
                if price.scan(/\d/).join('').to_i < 200000
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price, show_flg: true, push_flg: true, update_flg: true)
                else
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price)
                end
              elsif title.include?("상해") || title.include?("상하이")
                if price.scan(/\d/).join('').to_i < 180000
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price, show_flg: true, push_flg: true, update_flg: true)
                else
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price)
                end
              elsif title.include?("북경") || title.include?("베이징")
                if price.scan(/\d/).join('').to_i < 170000
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price, show_flg: true, push_flg: true, update_flg: true)
                else
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price)
                end
              elsif title.include?("홍콩")
                if price.scan(/\d/).join('').to_i < 170000
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price, show_flg: true, push_flg: true, update_flg: true)
                else
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price)
                end
              end
              
              # ['alo','hola','test'].any? { |word| str.include?(word) } #문자에 배열중에 같은 값을 포하고 있는지 비교
              # a.scan(/\d/).join('')  #문자&숫자에서 숫자만 가져옴
              
              
              event_hash = {event_id: event_id, event_name: event_name, event_url: event_url}
              @event_ary.push event_hash
            end
          end
        end
        
        lists = doc.css("#id_deal_list").css(".list-item")
        lists.each do |list|
          original_site = list.css(".areas").css(".area-info").text
          # list.css(".areas").css(".area-info").text.delete!("\n").delete!("\t").strip!
          original_site = list.css(".areas").css(".area-info").text
          original_site.delete!("\n").strip! if original_site.include?("\n")
          original_site.delete!("\t").strip! if original_site.include?("\t")
          
          title = list.css(".areas").css(".area-title").text
          if title.include?(type)
            rear_url = ""
            event_id = list.attr("data-did")
            event = Event.where(event_id: event_id, event_site_id: event_site_id)
            event_name = "[" + original_site + "]" +  title
            if event.blank?
              if "위메프".eql?(original_site)
                event_url = "http://www.wemakeprice.com/search?search_keyword=" + title
              elsif "티몬".eql?(original_site)
                event_url = "http://www.wemakeprice.com/search?search_keyword=" + title.split('/')[0]
              elsif "쿠팡".eql?(original_site)
                event_url = "http://m.coupang.com/np/search?q=" + title
                  # event_url = "http://www.coupang.com/np/search?q=" + title
              elsif "G마켓".eql?(original_site)
                event_url = "http://gtour.gmarket.co.kr/TourLP/Search?selecturl=total&keyword=" + title
              elsif "옥션 올킬".eql?(original_site)
                event_url = "http://stores.auction.co.kr/mrtour/List?keyword=" + title
              elsif "여행박사".eql?(original_site)
                event_url = ""
              else
                event_url = ""
              end
                
              image_url = list.css("img").attr("src").value
              price = list.css(".areas").css(".price-custom").text.delete!("\n").delete!("\t").strip!
              original_price = list.css(".areas").css(".price-origin").text.delete!("\n").delete!("\t").strip!
                
              #항공권이 15,000원 이하면 바로 푸시
              if title.include?("오사카")
                if price.scan(/\d/).join('').to_i < 150000
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price, show_flg: true, push_flg: true, update_flg: true)
                else
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price)
                end
              elsif title.include?("동경") || title.include?("도쿄")
                if price.scan(/\d/).join('').to_i < 200000
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price, show_flg: true, push_flg: true, update_flg: true)
                else
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price)
                end
              elsif title.include?("상해") || title.include?("상하이")
                if price.scan(/\d/).join('').to_i < 180000
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price, show_flg: true, push_flg: true, update_flg: true)
                else
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price)
                end
              elsif title.include?("북경") || title.include?("베이징")
                if price.scan(/\d/).join('').to_i < 170000
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price, show_flg: true, push_flg: true, update_flg: true)
                else
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price)
                end
              elsif title.include?("홍콩")
                if price.scan(/\d/).join('').to_i < 170000
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price, show_flg: true, push_flg: true, update_flg: true)
                else
                  Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, 
                                image_url: image_url, price: price, original_price: original_price)
                end
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
      end
    rescue => e
      p e.backtrace
      @title = "쿠차 오사카 항공권 error"
      @event_ary = []
      @event_ary.push "app/mailers/event_alram.rb"
      @err_msg = e.backtrace
      mail to: "shimtong1004@gmail.com" , subject: @title
      #send error mail
    end
  end
  
  def conveni_event_gs25(doc)
    begin
      @title = "편의점 알림"
      event_site_id = 3001
      front_url = "http://gs25.gsretail.com/"
      type = "편의점"

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
      @event_ary.push "app/mailers/event_alram_mailer_watir.rb"
      @err_msg = e.backtrace
      mail to: "shimtong1004@gmail.com" , subject: @title
      #send error mail
    end
  end
  
  def movie_event_megabox(doc)
    begin
      url = "http://www.megabox.co.kr/?menuId=store"
      @title = "[메가박스]"
      event_site_id = 4003

      lis = doc.css(".store_lst").css("li")
      @event_ary = []
      lis.each do |li|
        event_id = li.css(".blank").attr("data-code").value
        event = Event.where(event_id: event_id, event_site_id: event_site_id)
        if event.blank?
          title = li.css("h5").text
          price = li.css("b")[0].text
          price.lstrip!
          original_price = li.css("s").text
          event_name = "[메가박스]" + title 
          event_url = url
          image_url = li.css(".img_pro").attr("src").value
        
          if title.include?("1+1")
            Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price, 
                            show_flg: true, push_flg: true, update_flg: true)
          else
            Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price)
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
      @title = "메가박스 error"
      @event_ary = []
      @event_ary.push "app/mailers/event_alram_mailer_watir.rb"
      @err_msg = e.backtrace
      mail to: "shimtong1004@gmail.com" , subject: @title
      # render "event_mailer"
      #send error mail
    end
  end
  
  def get_g9_flash_deal(doc)
    begin
      event_site_id = 9002
      @title = "G9 FLASH DEAL"
      @event_ary = []
      unless doc.css("#flash_deal_goods_list").blank?
        title = doc.css("#flash_deal_goods_list").css(".title").text.delete!("\n").delete!("\t")
        price = doc.css("#flash_deal_goods_list").css(".price_info").css(".price").css("strong").text
        original_price = doc.css("#flash_deal_goods_list").css(".price_info").css(".price").css("del").text
        discount = doc.css("#flash_deal_goods_list").css(".price_info").css(".sale").text
        if doc.css("#flash_deal_goods_list").css(".tag")[0].attributes["href"] 
          rear_link_url = doc.css("#flash_deal_goods_list").css(".tag")[0].attributes["href"].value
          tmp_ary = rear_link_url.split("/")
          event_id = tmp_ary[-1]
          event_name = "[g9 FLASH DEAL]" + title
          event_url = url + rear_link_url
          event = Event.where(event_id: event_id, event_site_id: event_site_id)
          image_url = doc.css("#flash_deal_goods_list").css(".thumbnail")[0].attributes["src"].value
          if event.blank?
            Event.create(event_id: event_id.to_i, event_name: event_name, event_url: event_url, event_site_id: event_site_id, image_url: image_url, price: price, original_price: original_price, 
                            discount: discount, show_flg: true, push_flg: true, update_flg: true)
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
      @title = "지구 플레쉬딜 error"
      @event_ary = []
      @event_ary.push "app/mailers/event_alram_mailer_watir.rb"
      @err_msg = e.backtrace
      mail to: "shimtong1004@gmail.com" , subject: @title
    end
  end
  
end