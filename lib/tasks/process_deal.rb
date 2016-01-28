#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

headless = Headless.new
headless.start
browser = Watir::Browser.new
browser.driver.manage.timeouts.implicit_wait = 3
  i = 0
  while 1
    s = Time.now
    p "process start #{s}"
    # p "start add key 1"
    # DealSearchWord.add_key_wemakeprice(browser)
#     
    # p "start add key 2"
    # DealSearchWord.add_key_coupang(browser)
    
    #위메프
    # p "위메프"
    # ret = DealItem.add_wemakeprice(browser)
    # unless ret
      # p "위메프 error"
      # browser.close
      # headless.destroy
#       
      # headless = Headless.new
      # headless.start
      # browser = Watir::Browser.new
      # browser.driver.manage.timeouts.implicit_wait = 3
    # end
#     
    # #쿠팡
    # p "쿠팡"
    # ret = DealItem.add_coupang(browser)
    # unless ret
      # p "쿠팡 error"
      # browser.close
      # headless.destroy
#       
      # headless = Headless.new
      # headless.start
      # browser = Watir::Browser.new
      # browser.driver.manage.timeouts.implicit_wait = 3
    # end
    
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
    
    p "슈퍼꿀딜"
    ret = DealItem.add_tmon_super_ggul(browser)
    unless ret
      p "슈퍼꿀딜 error"
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
      browser.driver.manage.timeouts.implicit_wait = 3
    end
    
    #쇼킹딜
    # p "쇼킹딜"
    # ret = DealItem.add_shocking_deal(browser)
    # unless ret
      # p "쇼킹딜 error"
      # browser.close
      # headless.destroy
#       
      # headless = Headless.new
      # headless.start
      # browser = Watir::Browser.new
      # browser.driver.manage.timeouts.implicit_wait = 3
    # end
#     
    # #티몬
    # p "티몬"
    # ret = DealItem.add_tmon(browser)
    # @@isFirst = true
    # unless ret
      # p "티몬 error"
      # browser.close
      # headless.destroy
#       
      # headless = Headless.new
      # headless.start
      # browser = Watir::Browser.new
      # browser.driver.manage.timeouts.implicit_wait = 3
    # end
#     
    # p "옥션"
    # ret = DealItem.add_auction(browser)
    # unless ret
      # p "옥션 error"
      # browser.close
      # headless.destroy
#       
      # headless = Headless.new
      # headless.start
      # browser = Watir::Browser.new
      # browser.driver.manage.timeouts.implicit_wait = 3
    # end
    
    
    
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
    conveni_flg = true
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
  