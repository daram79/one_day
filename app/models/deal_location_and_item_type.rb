class DealLocationAndItemType < ActiveRecord::Base
  belongs_to :deal_search_word
  has_many :deal_location_keys
end
