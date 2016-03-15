#encoding: utf-8
require "#{File.dirname(__FILE__)}/../../config/environment.rb"
    start_date = Time.now.beginning_of_day
    end_date = Time.now.end_of_day
    
    start_date = start_date.yesterday
    end_date = end_date.yesterday
    
    #하루전 데이터
    #dau
    new_user_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "create_user").count
    EventLogHistory.create(label_text:"신규 회원", value: new_user_size, log_type: "new_user_count")
    
    dau = EventLog.where("created_at between  ? and ?", start_date, end_date).pluck("event_user_id")
    if dau.blank?
      dau_size = 0
    else
      dau_size = dau.uniq!.size
    end
    EventLogHistory.create(label_text:"활성유저", value: dau_size, log_type: "dau_count")
        
    connect_user_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "connect_user").count
    EventLogHistory.create(label_text:"접속 횟수", value: connect_user_size, log_type: "connect_count")
    
    
    #push 방문 접속자
    push_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_push").count
    EventLogHistory.create(label_text:"push 접속", value: push_size, log_type: "push_connect_count")
    
    #편의점 방문 접속자
    conveni_gs25_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_gs25").count
    EventLogHistory.create(label_text:"GS25 접속", value: conveni_gs25_size, log_type: "gs25_connect_count")
    
    
    conveni_seven_eleven_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_seven_eleven").count
    EventLogHistory.create(label_text:"세븐일레븐 접속", value: conveni_seven_eleven_size, log_type: "seven_eleven_connect_count")
    
    
    conveni_mini_stop_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_mini_stop").count
    EventLogHistory.create(label_text:"미니스톱 접속", value: conveni_mini_stop_size, log_type: "mini_stop_connect_count")
    
    
    conveni_cu_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_cu").count
    EventLogHistory.create(label_text:"CU 접속", value: conveni_cu_size, log_type: "cu_connect_count")
    
    conveni_search_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_conveni_search1+1").count
    EventLogHistory.create(label_text:"상품검색 접속", value: conveni_search_size, log_type: "search_connect_count")
    
    click_content_size = EventLog.where("created_at between  ? and ? and action_type = ?", start_date, end_date, "click_hotdeal_content").count
    EventLogHistory.create(label_text:"꿀딜클릭수", value: click_content_size, log_type: "gguldeal_content_click_count" )
    
    conveni_search_words = EventLog.where("created_at between  ? and ? and log_type = ?", start_date, end_date, "search_1+1").pluck(:action_type)
    conveni_search_words.each do |words|
      w = words.split("_")[-1]
      EventLogHistory.create(label_text:"검색단어", value: w, log_type: "search_word")
    end





