json.array!(@populars) do |popular|
  json.extract! popular, :id
  json.popular_photo popular.feed_photos[0]
  json.url popular_url(popular, format: :json)
end