class Feed < ActiveRecord::Base
  belongs_to :user
  has_many :likes, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :feed_photos, :dependent => :destroy
  has_many :feed_tags, :dependent => :destroy
  
  accepts_nested_attributes_for :feed_photos, reject_if: :feed_photos_attributes.blank?#, allow_destroy: true
  
  def self.make_tag(content_line)
    arr_tag = []
    if content_line.index("#")
      arr_line = content_line.split(" ")
      arr_line.each do |val|
        if val.count("#") > 0
          arr_tag += val.split("#").reject(&:empty?)
        end
      end
    end
    ret_arr = arr_tag.uniq
  end
  
  def self.get_tag(content)
    content = content.gsub(/(\r\n|\r|\n)/, " ") #개행삭제
    Feed.make_tag(content)
  end
  
  def self.create_tag(id, tags)
    tags.each do |tag|
      FeedTag.create(feed_id: id, tag_name: tag)
    end
  end
  
  def self.make_html(content, tags)
    html_content = content.clone
    html_content.gsub!(" ", "&nbsp;") #개행삭제
    html_content.gsub!(/(\r\n|\r|\n)/, "<br />")
    tags.each do |tag|
      _tag = "#" + tag
      html_content.gsub!(_tag, " <b><a href='search://#{tag}'>#{_tag}</a></b>")
    end
    html_content
  end
  
end
