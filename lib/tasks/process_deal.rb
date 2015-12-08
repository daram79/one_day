#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"




headless = Headless.new
headless.start
browser = Watir::Browser.new
  while 1
    # p "start add key 1"
    # DealSearchWord.add_key_wemakeprice(browser)
#     
    # p "start add key 2"
    # DealSearchWord.add_key_coupang(browser)
    
    search_key = DealSearchWord.all.pluck(:word)
    
    #위메프
    p "위메프"
    ret = DealItem.add_wemakeprice(browser, search_key)
    unless ret
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
    end
    
    #쿠팡
    p "쿠팡"
    ret = DealItem.add_coupang(browser, search_key)
    unless ret
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
    end
    
    #G9
    p "G9"
    ret = DealItem.add_g9(browser, search_key)
    unless ret
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
    end
    
    #쇼킹딜
    p "쇼킹딜"
    ret = DealItem.add_shocking_deal(browser, search_key)
    unless ret
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
    end
    
    #티몬
    p "티몬"
    ret = DealItem.add_tmon(browser, search_key)
    unless ret
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
    end
    
    p "메가박스"
    ret = DealItem.movie_event_megabox(browser)
    unless ret
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
    end
    
  end






