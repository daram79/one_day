class DealSearchResult < ActiveRecord::Base
  belongs_to :deal_item
end

# DealSearchResult.includes(:deal_item).where(deal_search_word: key).where("deal_items.deal_count>10000").references(:user_items)
# DealSearchResult.includes(:deal_item).where("deal_item.deal_count>10000").references(:user_items)


# DealSearchResult.joins(:deal_item).where(deal_search_word: key).where(deal_item: {"deal_count > 100"})
# DealSearchResult.joins(:deal_item).where(deal_search_word: key).where("deal_items.deal_count > 1000")


# User.joins(:posts).where(posts: { id: 1 })
# 
# User.includes(:user_items).where("user_items.number IS NULL").references(:user_items)