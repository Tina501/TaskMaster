class SubTask < ApplicationRecord
  belongs_to :task

  validates :title, presence: true

  def mark_as_completed!
    update(completed: true, completed_at: Time.current)
  end

  def mark_as_incomplete!
    update(completed: false, completed_at: nil)
  end
end
