#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

headless = Headless.new
headless.start
browser = Watir::Browser.new
  while 1
    search_key = DealSearchWord.all.pluck(:word)
    p "쿠팡"
    ret = DealItem.add_coupang(browser, search_key)
    unless ret
      browser.close
      headless.destroy
      
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new
    end
  end






