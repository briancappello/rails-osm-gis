# https://www.railstutorial.org/book/modeling_users#sec-format_validation
VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true,
                   length: { maximum: 50 }

  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true,
                       length: { minimum: 8 }

  # FIXME: better to use "method reference" convention for defining callbacks
  before_save { email.downcase! }

  def User.digest(str)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(str, cost: cost)
  end
end
