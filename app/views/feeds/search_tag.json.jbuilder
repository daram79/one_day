json.array!(@feeds) do |feed|
  json.extract! feed, :id
  json.feed_photo feed.feed_photos[0]
end
