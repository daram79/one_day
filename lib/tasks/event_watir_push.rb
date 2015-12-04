#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

  # event_sites = EventSite.all
  # event_sites.each do |event_site|
    # NoticeMailer.sendmail_confirm(event_site.id, event_site.site_name).deliver
  # end
  EventAlramMailerWatir.airticket_coocha_osaka.deliver
  EventAlramMailerWatir.movie_event_megabox.deliver
  EventAlramMailerWatir.conveni_event_gs25.deliver
  EventAlramMailerWatir.get_g9_flash_deal.deliver