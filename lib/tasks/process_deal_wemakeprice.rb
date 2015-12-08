#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

headless = Headless.new
headless.start
browser = Watir::Browser.new
  while 1
    search_key = DealSearchWord.all.pluck(:word)
    
    # #위메프
    ret = DealItem.add_wemakeprice(browser, search_key)
    unless ret
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
    end
  end
# browser.close
# headless.destroy






