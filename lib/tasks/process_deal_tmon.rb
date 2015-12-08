#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

headless = Headless.new
headless.start
browser = Watir::Browser.new
  while 1
    search_key = DealSearchWord.all.pluck(:word)
    
    #티몬
    p "티몬"
    DealItem.add_tmon(browser, search_key)
  end
browser.close
headless.destroy






