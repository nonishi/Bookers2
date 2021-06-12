class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :books, dependent: :destroy
  attachment :profile_image
  
  validates :name, uniqueness: true, length: {in: 2..20}
  validates :introduction, length: {maximum: 50}
end
