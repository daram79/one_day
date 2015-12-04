#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

  event_sites = EventSite.all
  event_sites.each do |event_site|
    NoticeMailer.sendmail_confirm(event_site.id, event_site.site_name).deliver if event_site.id < 11
  end