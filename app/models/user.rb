class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

has_many :posts, dependent: :destroy
has_many :favorites, dependent: :destroy
has_many :post_comments, dependent: :destroy

#フォロー機能に関する記述。理解不能
has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
has_many :followers, through: :reverse_of_relationships, source: :follower

has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
has_many :followings, through: :relationships, source: :followed

has_many :user_rooms
has_many :chats
has_many :rooms, through: :user_rooms






has_one_attached :profile_image

def get_profile_image(width, height)
  unless profile_image.attached?
    file_path = Rails.root.join('app/assets/images/no_image.jpg')
    profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
  end
  profile_image.variant(resize_to_limit: [width, height]).processed
end



 def follow(user)
    relationships.create(followed_id: user.id)
 end

  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

#検索機能の記述
def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end

end
