json.array!(@alrams) do |alram|
  json.extract! alram, :id, :alram_type, :created_at
  json.time_word @time_word[alram.id]
  json.friend_user alram.send_user
  json.feed_photo alram.alram.feed.feed_photos.first
  json.url alram_url(alram, format: :json)
end