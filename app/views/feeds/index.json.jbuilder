json.array!(@feeds) do |feed|
  json.extract! feed, :id, :user_id, :nick, :content, :html_content, :like_count, :comment_count, :created_at
  json.time_word @time_word[feed.id]
  json.user feed.user
  json.feed_photo feed.feed_photos[0]
  json.like_count feed.likes.count
  json.comment_count feed.comments.count
  json.current_user_id @current_user.id
  if feed.likes.find_by_user_id(@current_user.id)
    json.is_like true
  else
    json.is_like false
  end
end