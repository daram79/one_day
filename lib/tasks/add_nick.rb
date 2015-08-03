#encoding: utf-8

require "#{File.dirname(__FILE__)}/../../config/environment.rb"
f_nicks = ["도도한", "청순한", "섹시", "귀여운", "착한", "사랑스러운", "열정적인", "냉정한", "즐거운", "기분좋은", "시크한", "비판적인", "인기많은", "침착한", "당황한", "행복한", "고독한", "순진한", "깔끔한", "낭만", "로맨틱",
          "싱그러운", "상냥한", "우아한", "잘 웃는", "자유로운", "친절한", "훌륭한", "호감가는", "매력적인"]
s_nicks = ["고양이", "토끼", "여우", "악어", "곰돌이", "앵무새", "치타", "침팬지", "개코원숭이", "돌고래", "두더지", "고슴도치", "오랑우탄", "바다사자", "하이에나", "팬더", "나무늘보", "아프리카코끼리", "수달", "코알라", "얼룩말", 
            "사자", "개미핥기", "하마", "펭귄", "캥거루", "강아지", "공룡", "기린", "공작"]
            
f_nicks.each do |f|
  UserFirstNick.create(nick: f)
end

s_nicks.each do |s|
  UserSecondNick.create(nick: s)
end
# puts "push start " + Time.now.to_s
# alrams = Alram.where(send_flg: false)
# registration_id = Alram.where(send_flg: false).group(:user_id).includes(:user).pluck(:registration_id)
# registration_id.compact
# unless registration_id.blank?
  # gcm = GCM.new("AIzaSyDyxck6hFnEtoBkTz3FNdvme3w3csLdTWA")
  # response = gcm.send(registration_id)
  # alrams.update_all(send_flg: true)
# end
# puts "push start " + Time.now.to_s