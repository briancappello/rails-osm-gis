class Picture < ApplicationRecord
  mount_uploader :file, ::PictureUploader
  validates :file, presence: true
end
