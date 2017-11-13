class Trail < ApplicationRecord
  belongs_to :location
  has_many :rides, dependent: :destroy
  validates :name, presence: true, uniqueness: { scope: :location }
end
