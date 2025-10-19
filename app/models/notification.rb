class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  validates :action, presence: true
  scope :unread, -> { where(read_at: nil) }
end