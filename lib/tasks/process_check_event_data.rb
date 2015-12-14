#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

# G9
g9s = Event.where(event_site_id: 1003)
g9s.each do |g9|
  html_str = open(g9.event_url).read
  doc = Nokogiri::HTML(html_str)
  if doc.css("#spSoldOutText").blank?
    g9.update(show_flg: 1)
  else
    g9.update(show_flg: 0)
  end
end