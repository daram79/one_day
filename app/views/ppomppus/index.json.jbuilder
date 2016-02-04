json.array!(@ppomppus) do |ppomppu|
  json.extract! ppomppu, :id
  json.url ppomppu_url(ppomppu, format: :json)
end
