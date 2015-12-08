#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

headless = Headless.new
headless.start
browser = Watir::Browser.new
  while 1
    search_key = DealSearchWord.all.pluck(:word)
    p "쿠팡"
    DealItem.add_coupang(browser, search_key)
  end
browser.close
headless.destroy






