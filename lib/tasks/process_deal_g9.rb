#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

headless = Headless.new
headless.start
browser = Watir::Browser.new
  while 1
    search_key = DealSearchWord.all.pluck(:word)
    
    #G9
    p "G9"
    DealItem.add_g9(browser, search_key)
  end
browser.close
headless.destroy






