class Post < ApplicationRecord
  has_one_attached :post_image

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :caption, presence: true

  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }

  def save_tags(savepost_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?

    old_tags = current_tags - savepost_tags
    new_tags = savepost_tags - current_tags

    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name: old_name)
    end

    new_tags.each do |new_name|
      post_tag = Tag.find_or_create_by(name: new_name)
      self.tags << post_tag
    end
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def get_post_image(width, height)
    post_image.variant(resize_to_limit: [width, height]).processed
  end

  def self.search_for(content, method)
    if method == 'perfect'
      Post.where(caption: content)
    elsif method == 'partial'
      Post.where('caption LIKE ?', '%' + content + '%')
    end
  end
end