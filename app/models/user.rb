class User < ActiveRecord::Base
  validates :user_name, presence: true

  validates :email, presence: true, uniqueness: true,
  :format => { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}

  validates :organization, presence: true

  validates :designation, presence: true
end
