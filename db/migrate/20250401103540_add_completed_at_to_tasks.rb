class AddCompletedAtToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :completed_at, :datetime
  end
end
