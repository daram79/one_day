#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

#편의점
# GS는 다른서버에서 보냄(페이지를 읽은후 보내야 해서)
# EventAlramMailer.conveni_event_ministop.deliver
# EventAlramMailer.conveni_event_cu.deliver
# EventAlramMailer.conveni_event_711.deliver
EventAlramMailer.conveni_event_cu.deliver
EventAlramMailer.conveni_event_711.deliver