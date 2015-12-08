#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"




# headless = Headless.new
# headless.start
browser = Watir::Browser.new
  while 1
    DealSearchWord.add_key_wemakeprice(browser)
    DealSearchWord.add_key_coupang(browser)
    
    search_key = DealSearchWord.all.pluck(:word)
    
    # #위메프
    DealItem.add_wemakeprice(browser, search_key)
    
    # #쿠팡
    DealItem.add_coupang(browser, search_key)
    
    # #G9
    DealItem.add_g9(browser, search_key)
    
    # #쇼킹딜
    DealItem.add_shocking_deal(browser, search_key)
    
    # #티몬
    DealItem.add_tmon(browser, search_key)
    
  end
browser.close
# headless.destroy






