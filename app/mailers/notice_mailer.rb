# coding : utf-8
require 'open-uri'
class NoticeMailer < ActionMailer::Base
  #デフォルトのヘッダ情報
  default to: Proc.new { EventMailingList.where(send_flg: true).pluck(:email) }, from: 'shimtong1004@gmail.com'
  # default to: Proc.new { ["tellus.event@gmail.com"] }, from: 'shimtong1004@gmail.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.sendmail_confirm.subject
  #
  def sendmail_confirm(event_site_id, site_name)
    @title = "#{site_name} 이벤트 알림"
    @event_ary = []
    case event_site_id
    when 1  
      @event_ary = Event.get_cgv_data(event_site_id)
    when 2
      @event_ary = Event.get_lotteciname_data(event_site_id)
    when 3
      @event_ary = Event.get_clien_sale_data(event_site_id)
    when 4
      @event_ary = Event.get_clien_event_data(event_site_id)
    when 5
      @event_ary = Event.get_naver_sg_data(event_site_id)
    when 6
      @event_ary = Event.get_coex_data(event_site_id)
    else
      return
    end
    return if @event_ary.blank?
    mail subject: @title
  end
  
end