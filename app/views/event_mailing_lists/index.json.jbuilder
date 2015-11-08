json.array!(@event_mailing_lists) do |event_mailing_list|
  json.extract! event_mailing_list, :id
  json.url event_mailing_list_url(event_mailing_list, format: :json)
end
