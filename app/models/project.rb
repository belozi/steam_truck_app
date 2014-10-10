class Project < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order('created_at DESC') }
	validates :project_title, presence: true, length: { maximum: 90 }
	validates :description, presence: true, length: { maximum: 800 }
	validates :problem, presence: true, length: { maximum: 300 }
	validates :solution, presence: true, length: { maximum: 300 }
	validates :status, presence: true, length: { maximum: 100 }
	validates :user_id, presence: true
	mount_uploader :image, PicUploader
end
