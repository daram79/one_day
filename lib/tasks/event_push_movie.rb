#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

#편의점
# 메가박스는 다른서버에서 보냄(페이지를 읽은후 보내야 해서)
MovieAlramMailer.movie_event_cgv.deliver
# MovieAlramMailer.movie_event_lotteciname.deliver