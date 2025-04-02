class Task < ApplicationRecord
  belongs_to :user
  has_many :collaborations, dependent: :destroy
  has_many :collaborators, through: :collaborations, source: :user

  validates :title, presence: true
  validates :description, presence: true
  validates :priority, inclusion: { in: [1, 2, 3], message: "must be 1 (low), 2 (medium), or 3 (high)" }
  validates :deadline, presence: true

  scope :today, -> { where("DATE(deadline) = ?", Date.today) }

  def mark_as_completed!
    update(completed: true, completed_at: Time.current)
  end
end
