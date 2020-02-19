class Micropost < ApplicationRecord
  belongs_to :user
  scope :recent_posts, ->{order created_at: :asc}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  private

  def picture_size
    errors.add :picture, (t".min_size_pic") if picture.size > 5.megabytes
  end
end
