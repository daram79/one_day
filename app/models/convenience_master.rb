class ConvenienceMaster < ActiveRecord::Base
  has_many :convenience_item_keywords
  has_many :convenience_items
end
