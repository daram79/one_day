#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"




# headless = Headless.new
# headless.start
browser = Watir::Browser.new
  while 1
    # p "start add key 1"
    # DealSearchWord.add_key_wemakeprice(browser)
#     
    # p "start add key 2"
    # DealSearchWord.add_key_coupang(browser)
#     
    search_key = DealSearchWord.all.pluck(:word)
#     
    # # #위메프
    # p "start 1"
    # DealItem.add_wemakeprice(browser, search_key)
#     
    # # #쿠팡
    # p "start 2"
    DealItem.add_coupang(browser, search_key)
#     
    # # #G9
    # p "start 3"
    # DealItem.add_g9(browser, search_key)
#     
    # # #쇼킹딜
    # p "start 4"
    # DealItem.add_shocking_deal(browser, search_key)
#     
    # # #티몬
    # p "start 5"
    # DealItem.add_tmon(browser, search_key)
    
    # p "start megabox"
    # DealItem.movie_event_megabox(browser)
    
  end
browser.close
# headless.destroy






