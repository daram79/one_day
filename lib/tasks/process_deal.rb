#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

headless = Headless.new
headless.start
browser = Watir::Browser.new
browser.driver.manage.timeouts.implicit_wait = 3
conveni_flg = true
  i = 0
  while 1
    s = Time.now
    p "process start #{s}"
    
    
    p "티몬 - 서치"
    ret = DealItem.timon_clothes(browser)
    unless ret
      p "티몬 서치 error"
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
      browser.driver.manage.timeouts.implicit_wait = 3
    end
    
    
    p "쿠팡 - 서치"
    ret = DealItem.read_cupang
    unless ret
      p "쿠팡 서치 error"
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
      browser.driver.manage.timeouts.implicit_wait = 3
    end
    
    p "티몬 - 서치"
    ret = DealItem.read_timon(browser)
    unless ret
      p "티몬 서치 error"
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
      browser.driver.manage.timeouts.implicit_wait = 3
    end
    
    p "위메프 - 서치"
    ret = DealItem.read_wemakeprice(browser)
    unless ret
      p "위메프 서치 error"
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
      browser.driver.manage.timeouts.implicit_wait = 3
    end
    
    p "11번가 - 서치"
    ret = DealItem.read_11st(browser)
    unless ret
      p "11번가 서치 error"
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
      browser.driver.manage.timeouts.implicit_wait = 3
    end
    
    p "G9 - 서치"
    ret = DealItem.read_g9(browser)
    unless ret
      p "G9 서치 error"
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
      browser.driver.manage.timeouts.implicit_wait = 3
    end
    
    p "옥션 - 서치"
    ret = DealItem.read_auction(browser)
    unless ret
      p "옥션 서치 error"
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
      browser.driver.manage.timeouts.implicit_wait = 3
    end
    
    #G9
    p "G9"
    ret = DealItem.add_g9(browser)
    unless ret
      p "G9 error"
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
      browser.driver.manage.timeouts.implicit_wait = 3
    end
    
    # p "슈퍼꿀딜"
    # ret = DealItem.add_tmon_super_ggul(browser)
    # unless ret
      # p "슈퍼꿀딜 error"
      # browser.close
      # headless.destroy
#       
      # headless = Headless.new
      # headless.start
      # browser = Watir::Browser.new
      # browser.driver.manage.timeouts.implicit_wait = 3
    # end
    
    p "롯데시네마"
    ret = DealItem.movie_event_lotteciname(browser)
    unless ret
      p "롯데시네마 error"
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
      browser.driver.manage.timeouts.implicit_wait = 3
    end
    
    
    
    p "메가박스"
    ret = DealItem.movie_event_megabox(browser)
    unless ret
      p "메가박스 error"
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
      browser.driver.manage.timeouts.implicit_wait = 3
    end
    e = Time.now
    
    #이벤트 일괄 처리
    p "이벤트 일괄 처리"
    begin
      data = EventAddWaitUrl.where(is_add: false)
      p "입력할 데이터 수: #{data.count}"
      Event.add_item_from_url(data, browser) unless data.blank?
    rescue
      p "일괄등록 error"
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
      browser.driver.manage.timeouts.implicit_wait = 3
    end
    
    p "process end #{e}"
    p "걸린 시간: #{e - s}"
    
    #event data check
    # i += 1
    # if i % 10 == 0
      # s = Time.now
      # p "이벤트 체크 start #{s}"
      # ret = Event.check_event_data(browser)
      # unless ret
        # p "이벤트 체크 error"
        # browser.close
        # headless.destroy
#         
        # headless = Headless.new
        # headless.start
        # browser = Watir::Browser.new
        # browser.driver.manage.timeouts.implicit_wait = 3
      # end
      # e = Time.now
      # p "이벤트 체크 end #{e}"
      # p "이벤트 체크 걸린 시간: #{e - s}"
      # i = 0
    # end
    
    start_at = Time.now.beginning_of_month
    end_at = Time.now.beginning_of_month.change(min: 10)
    if Time.now  > start_at && Time.now < end_at && conveni_flg
      conveni_flg = false
      ret = DealItem.gs25(browser)
      unless ret
        p "GS25 error"
        browser.close
        headless.destroy
        
        headless = Headless.new
        headless.start
        browser = Watir::Browser.new
        browser.driver.manage.timeouts.implicit_wait = 3
      end
      ret = DealItem.cu(browser)
      unless ret
        p "CU error"
        browser.close
        headless.destroy
        
        headless = Headless.new
        headless.start
        browser = Watir::Browser.new
        browser.driver.manage.timeouts.implicit_wait = 3
      end
      ret = DealItem.seven_eleven(browser)
      unless ret
        p "세븐일레븐 error"
        browser.close
        headless.destroy
        
        headless = Headless.new
        headless.start
        browser = Watir::Browser.new
        browser.driver.manage.timeouts.implicit_wait = 3
      end
      
      ret = DealItem.mini_stop(browser)
      unless ret
        p "미니스탑 error"
        browser.close
        headless.destroy
        
        headless = Headless.new
        headless.start
        browser = Watir::Browser.new
        browser.driver.manage.timeouts.implicit_wait = 3
      end
    elsif Time.now > end_at
      conveni_flg = true
    end
    
  end
  