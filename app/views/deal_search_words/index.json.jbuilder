json.array!(@deal_search_words) do |deal_search_word|
  json.extract! deal_search_word, :id
  json.url deal_search_word_url(deal_search_word, format: :json)
end
