class ConvenienceMaster < ActiveRecord::Base
  has_many :conveni_item_keywords
  has_many :conveni_items
end
