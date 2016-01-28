json.array!(@convenience_items) do |convenience_item|
  json.extract! convenience_item, :id
  json.url convenience_item_url(convenience_item, format: :json)
end
