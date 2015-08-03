json.extract! @feed, :id, :user_id, :nick, :content, :html_content, :created_at, :updated_at
json.user @feed.user
json.feed_photo @feed.feed_photos[0]
json.comment_count @feed.comment_count
json.like_count @feed.like_count
json.time_word @time_word
if @current_user && @feed.likes.find_by_user_id(@current_user.id)
  json.is_like true
else
  json.is_like false
end