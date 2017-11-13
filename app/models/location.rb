class Location < ApplicationRecord
  has_many :trails, dependent: :destroy

  validates :name, presence: true
end
