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
    
    coocha_osaka2_url = "http://m.coocha.co.kr/search/search.do?keyword=%EC%98%A4%EC%82%AC%EC%B9%B4+%ED%95%AD%EA%B3%B5&menuCid=&cCate0=&cCate1=&cCate2=&cCate3=&searchCateName=&cid=&cSido=&searchAreas=&searchAreasName=&storesNationwide=&marketCurPageNo=&shopCode=&shopName=&curPageNo=0&orderbyGubun=&searchGubun=&minPrice=-1&maxPrice=-1&searchDate=&inner_keyword=&originCid=1&recmdDataList=&solrDataType=mall&solrDataIndex=1&searchSolr=on&searchTabIndex=1&mdRcmdId=0&anchor_did="
    browser.goto(coocha_osaka2_url)
    coocha_osaka2_doc = Nokogiri::HTML.parse(browser.html)
    
    coocha_tokyo_url = "http://m.coocha.co.kr/search/search.do?keyword=%EB%8F%99%EA%B2%BD+%ED%95%AD%EA%B3%B5%EA%B6%8C&menuCid=&cCate0=&cCate1=&cCate2=&cCate3=&searchCateName=&cid=&cSido=&searchAreas=&searchAreasName=&storesNationwide=&marketCurPageNo=&shopCode=&shopName=&curPageNo=0&orderbyGubun=&searchGubun=&minPrice=-1&maxPrice=-1&searchDate=&inner_keyword=&originCid=1&recmdDataList=&solrDataType=mall&solrDataIndex=1&searchSolr=on&searchTabIndex=1&mdRcmdId=0&anchor_did="
    browser.goto(coocha_tokyo_url)
    coocha_tokyo_doc = Nokogiri::HTML.parse(browser.html)
    
    coocha_tokyo2_url = "http://m.coocha.co.kr/search/search.do?keyword=%EB%8F%99%EA%B2%BD+%ED%95%AD%EA%B3%B5&menuCid=&cCate0=&cCate1=&cCate2=&cCate3=&searchCateName=&cid=&cSido=&searchAreas=&searchAreasName=&storesNationwide=&marketCurPageNo=&shopCode=&shopName=&curPageNo=0&orderbyGubun=&searchGubun=&minPrice=-1&maxPrice=-1&searchDate=&inner_keyword=&originCid=1&recmdDataList=&solrDataType=mall&solrDataIndex=1&searchSolr=on&searchTabIndex=1&mdRcmdId=0&anchor_did="
    browser.goto(coocha_tokyo2_url)
    coocha_tokyo2_doc = Nokogiri::HTML.parse(browser.html)
    
    coocha_sanghai_url = "http://m.coocha.co.kr/search/search.do?keyword=%EC%83%81%ED%95%B4+%ED%95%AD%EA%B3%B5%EA%B6%8C&menuCid=&cCate0=&cCate1=&cCate2=&cCate3=&searchCateName=&cid=&cSido=&searchAreas=&searchAreasName=&storesNationwide=&marketCurPageNo=&shopCode=&shopName=&curPageNo=0&orderbyGubun=&searchGubun=&minPrice=-1&maxPrice=-1&searchDate=&inner_keyword=&originCid=1&recmdDataList=&solrDataType=mall&solrDataIndex=1&searchSolr=on&searchTabIndex=1&mdRcmdId=0&anchor_did="
    browser.goto(coocha_sanghai_url)
    coocha_sanghai_doc = Nokogiri::HTML.parse(browser.html)
    
    coocha_sanghai2_url = "http://m.coocha.co.kr/search/search.do?keyword=%EC%83%81%ED%95%B4+%ED%95%AD%EA%B3%B5&menuCid=&cCate0=&cCate1=&cCate2=&cCate3=&searchCateName=&cid=&cSido=&searchAreas=&searchAreasName=&storesNationwide=&marketCurPageNo=&shopCode=&shopName=&curPageNo=0&orderbyGubun=&searchGubun=&minPrice=-1&maxPrice=-1&searchDate=&inner_keyword=&originCid=1&recmdDataList=&solrDataType=mall&solrDataIndex=1&searchSolr=on&searchTabIndex=1&mdRcmdId=0&anchor_did="
    browser.goto(coocha_sanghai2_url)
    coocha_sanghai2_doc = Nokogiri::HTML.parse(browser.html)
    
    coocha_beijing_url = "http://m.coocha.co.kr/search/search.do?keyword=%EB%B6%81%EA%B2%BD+%ED%95%AD%EA%B3%B5%EA%B6%8C&menuCid=&cCate0=&cCate1=&cCate2=&cCate3=&searchCateName=&cid=&cSido=&searchAreas=&searchAreasName=&storesNationwide=&marketCurPageNo=&shopCode=&shopName=&curPageNo=0&orderbyGubun=&searchGubun=&minPrice=-1&maxPrice=-1&searchDate=&inner_keyword=&originCid=1&recmdDataList=&solrDataType=mall&solrDataIndex=1&searchSolr=on&searchTabIndex=1&mdRcmdId=0&anchor_did="
    browser.goto(coocha_beijing_url)
    coocha_beijing_doc = Nokogiri::HTML.parse(browser.html)
    
    coocha_beijing2_url = "http://m.coocha.co.kr/search/search.do?keyword=%EB%B6%81%EA%B2%BD+%ED%95%AD%EA%B3%B5&menuCid=&cCate0=&cCate1=&cCate2=&cCate3=&searchCateName=&cid=&cSido=&searchAreas=&searchAreasName=&storesNationwide=&marketCurPageNo=&shopCode=&shopName=&curPageNo=0&orderbyGubun=&searchGubun=&minPrice=-1&maxPrice=-1&searchDate=&inner_keyword=&originCid=1&recmdDataList=&solrDataType=mall&solrDataIndex=1&searchSolr=on&searchTabIndex=1&mdRcmdId=0&anchor_did="
    browser.goto(coocha_beijing2_url)
    coocha_beijing2_doc = Nokogiri::HTML.parse(browser.html)
    
    coocha_hongkong_url = "http://m.coocha.co.kr/search/search.do?keyword=%ED%99%8D%EC%BD%A9+%ED%95%AD%EA%B3%B5%EA%B6%8C&menuCid=&cCate0=&cCate1=&cCate2=&cCate3=&searchCateName=&cid=&cSido=&searchAreas=&searchAreasName=&storesNationwide=&marketCurPageNo=&shopCode=&shopName=&curPageNo=0&orderbyGubun=&searchGubun=&minPrice=-1&maxPrice=-1&searchDate=&inner_keyword=&originCid=1&recmdDataList=&solrDataType=mall&solrDataIndex=1&searchSolr=on&searchTabIndex=1&mdRcmdId=0&anchor_did="
    browser.goto(coocha_hongkong_url)
    coocha_hongkong_doc = Nokogiri::HTML.parse(browser.html)
    
    coocha_hongkong2_url = "http://m.coocha.co.kr/search/search.do?keyword=%ED%99%8D%EC%BD%A9+%ED%95%AD%EA%B3%B5&menuCid=&cCate0=&cCate1=&cCate2=&cCate3=&searchCateName=&cid=&cSido=&searchAreas=&searchAreasName=&storesNationwide=&marketCurPageNo=&shopCode=&shopName=&curPageNo=0&orderbyGubun=&searchGubun=&minPrice=-1&maxPrice=-1&searchDate=&inner_keyword=&originCid=1&recmdDataList=&solrDataType=mall&solrDataIndex=1&searchSolr=on&searchTabIndex=1&mdRcmdId=0&anchor_did="
    browser.goto(coocha_hongkong2_url)
    coocha_hongkong2_doc = Nokogiri::HTML.parse(browser.html)
      
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
  
#  오사카
  EventAlramMailerWatir.airticket_coocha(coocha_osaka_doc, 2002).deliver
  EventAlramMailerWatir.airticket_coocha(coocha_osaka2_doc, 2002).deliver

#  동경  
  EventAlramMailerWatir.airticket_coocha(coocha_tokyo_doc, 2003).deliver
  EventAlramMailerWatir.airticket_coocha(coocha_tokyo2_doc, 2003).deliver
  
#  상해
  EventAlramMailerWatir.airticket_coocha(coocha_sanghai_doc, 2004).deliver
  EventAlramMailerWatir.airticket_coocha(coocha_sanghai2_doc, 2004).deliver
  
#  북경
  EventAlramMailerWatir.airticket_coocha(coocha_beijing_doc, 2005).deliver
  EventAlramMailerWatir.airticket_coocha(coocha_beijing2_doc, 2005).deliver
  
#  홍콩
  EventAlramMailerWatir.airticket_coocha(coocha_hongkong_doc, 2006).deliver
  EventAlramMailerWatir.airticket_coocha(coocha_hongkong2_doc, 2006).deliver
  
  
  EventAlramMailerWatir.get_g9_flash_deal(g9_doc).deliver
  EventAlramMailerWatir.movie_event_megabox(megabox_doc).deliver
  EventAlramMailerWatir.conveni_event_gs25(gs25_doc).deliver
  