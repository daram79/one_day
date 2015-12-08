#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

headless = Headless.new
headless.start
browser = Watir::Browser.new
  while 1
    search_key = DealSearchWord.all.pluck(:word)
    
    # #위메프
    p "start 1"
    DealItem.add_wemakeprice(browser, search_key)
  end
browser.close
headless.destroy






