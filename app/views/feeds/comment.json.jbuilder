json.array!(@comments) do |comment|
  json.extract! comment, :id, :content, :nick
  json.time_word @time_word[comment.id] 
  json.user_id comment.user.id
end