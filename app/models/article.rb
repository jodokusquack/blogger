class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_attached_file :image, styles: {medium:"150x150"}
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  def tag_list
    tags.join(", ")
  end

  def tag_list=(tags_string)
    tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq
    new_or_found_tags = tag_names.collect{ |name| Tag.find_or_create_by(name: name)}
    self.tags = new_or_found_tags
  end

  def increment_view_count
    if self.view_count == nil
      self.view_count = 1
    else
      self.view_count += 1
    end
    self.save
  end
end
