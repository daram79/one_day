#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

  # event_sites = EventSite.all
  # event_sites.each do |event_site|
    # NoticeMailer.sendmail_confirm(event_site.id, event_site.site_name).deliver
  # end
  # EventAlramMailerWatir.airticket_coocha_osaka.deliver
  # EventAlramMailerWatir.movie_event_megabox.deliver
  # EventAlramMailerWatir.conveni_event_gs25.deliver
  # EventAlramMailerWatir.get_g9_flash_deal.deliver


  headless = Headless.new
  headless.start
    coocha_osaka_url = "http://m.coocha.co.kr/search/search.do?keyword=%EC%98%A4%EC%82%AC%EC%B9%B4+%ED%95%AD%EA%B3%B5%EA%B6%8C&menuCid=&cCate0=&cCate1=&cCate2=&cCate3=&searchCateName=&cid=&cSido=&searchAreas=&searchAreasName=&storesNationwide=&marketCurPageNo=&shopCode=&shopName=&curPageNo=1&orderbyGubun=&searchGubun=&minPrice=-1&maxPrice=-1&searchDate=&inner_keyword=&originCid=1&recmdDataList=&solrDataType=mall&solrDataIndex=1&searchSolr=on&searchTabIndex=0&mdRcmdId=0&anchor_did="
    browser = Watir::Browser.start coocha_osaka_url
    begin
      browser.link(:onclick=>"footerBannerClose();").click
    rescue
    end
    coocha_osaka_doc = Nokogiri::HTML.parse(browser.html)
      
    g9_url = "http://www.g9.co.kr"
    browser.goto(g9_url)
    g9_doc = Nokogiri::HTML.parse(browser.html)
      
    megabox_url = "http://www.megabox.co.kr/?menuId=store"
    browser.goto(megabox_url)
    megabox_doc = Nokogiri::HTML.parse(browser.html)
      
      
    gs25_url = "http://gs25.gsretail.com/gscvs/ko/customer-engagement/event/current-events"
    browser.goto(gs25_url)
    gs25_doc = Nokogiri::HTML.parse(browser.html)
    browser.close
  headless.destroy
      
  EventAlramMailerWatir.airticket_coocha_osaka(coocha_osaka_doc).deliver
  EventAlramMailerWatir.get_g9_flash_deal(g9_doc).deliver
  EventAlramMailerWatir.movie_event_megabox(megabox_doc).deliver
  EventAlramMailerWatir.conveni_event_gs25(gs25_doc).deliver
  