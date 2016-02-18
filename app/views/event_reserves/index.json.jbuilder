json.array!(@event_reserves) do |event_reserve|
  json.extract! event_reserve, :id
  json.url event_reserve_url(event_reserve, format: :json)
end
