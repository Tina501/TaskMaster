class Task < ApplicationRecord
  belongs_to :user
  has_many :collaborations, dependent: :destroy
  has_many :collaborators, through: :collaborations, source: :user
  has_many :sub_tasks, dependent: :destroy

  accepts_nested_attributes_for :sub_tasks, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :collaborations, allow_destroy: true, reject_if: :all_blank

  validates :title, presence: true
  validates :description, presence: true
  validates :priority, inclusion: { in: [1, 2, 3], message: "must be 1 (low), 2 (medium), or 3 (high)" }
  validates :deadline, presence: true

  scope :today, -> { where("DATE(deadline) = ?", Date.today) }

  def mark_as_completed!
    update(completed: true, completed_at: Time.current)
  end
end
