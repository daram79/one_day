#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

headless = Headless.new
headless.start
browser = Watir::Browser.new
  while 1
    s = Time.now
    p "process start #{s}"
    # p "start add key 1"
    # DealSearchWord.add_key_wemakeprice(browser)
#     
    # p "start add key 2"
    # DealSearchWord.add_key_coupang(browser)
    
    #위메프
    p "위메프"
    ret = DealItem.add_wemakeprice(browser)
    unless ret
      p "위메프 error"
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
    end
    
    #쿠팡
    p "쿠팡"
    ret = DealItem.add_coupang(browser)
    unless ret
      p "쿠팡 error"
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
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
    end
    
    #쇼킹딜
    p "쇼킹딜"
    ret = DealItem.add_shocking_deal(browser)
    unless ret
      p "쇼킹딜 error"
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
    end
    
    #티몬
    p "티몬"
    ret = DealItem.add_tmon(browser)
    @@isFirst = true
    unless ret
      p "티몬 error"
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
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
    end
    e = Time.now
    p "process end #{e}"
    p "걸린 시간: #{e - s}"
    
    #event data check
    s = Time.now
    p "이벤트 체크 start #{s}"
    ret = Event.check_event_data(browser)
    e = Time.now
    p "이벤트 체크 end #{e}"
    p "이벤트 체크 걸린 시간: #{e - s}"
    
    
    
  end
  