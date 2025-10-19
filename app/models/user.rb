class User < ActiveRecord::Base
  has_secure_password
  has_many :posts
  has_many :comments
  has_one_attached :avatar
  
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  
  serialize :fitness_stats, Hash
end