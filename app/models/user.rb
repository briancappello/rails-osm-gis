# https://www.railstutorial.org/book/modeling_users#sec-format_validation
VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

class User < ApplicationRecord
  has_secure_password
  attr_accessor :remember_token

  has_many :microposts, dependent: :destroy

  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true,
                   length: { maximum: 50 }

  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true,
                       allow_nil: true,
                       length: { minimum: 8 }

  # FIXME: better to use "method reference" convention for defining callbacks
  before_save { email.downcase! }

  def User.digest(str)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(str, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_token
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def admin?
    self.admin
  end

  def feed
    Micropost.where('user_id = :user_id
                     OR user_id in (
                       SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id
                     )', user_id: id)
  end

  def follow(other_user)
    self.following << other_user
  end

  def unfollow(other_user)
    self.following.delete(other_user)
  end

  def following?(other_user)
    self.following.include?(other_user)
  end

end
