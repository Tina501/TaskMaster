class User < ApplicationRecord
  # Devise authentication modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tasks, dependent: :destroy
  has_many :collaborations, dependent: :destroy
  has_many :shared_tasks, through: :collaborations, source: :task
end
