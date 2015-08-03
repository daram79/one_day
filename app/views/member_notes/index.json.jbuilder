json.array!(@member_notes) do |feed|
  json.extract! feed, :id, :user_id, :nick, :content, :html_content, :created_at
  json.time_word @time_word[feed.id]
  json.user feed.user
  json.feed_photo feed.feed_photos[0]
  json.like_count feed.like_count
  json.comment_count feed.comment_count
  json.current_user_id @current_user.id
  if feed.likes.find_by_user_id(@current_user.id)
    json.is_like true
  else
    json.is_like false
  end
end