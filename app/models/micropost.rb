class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.maxcontent}
  validate :picture_size
  scope :recent_posts, ->{order created_at: :asc}
  scope :by_author, ->(user_id){where user_id: user:id}
  private

  def picture_size
    errors.add :picture, (t".size_img") if picture.size > (Settings.picture).megabytes
  end
end
