#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"
    NoticeMailer.sendmail_confirm.deliver