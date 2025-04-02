class AddCompletedAtToTasks < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:tasks, :completed_at)
      add_column :tasks, :completed_at, :datetime
      add_index :tasks, :completed_at
    end
  end
end
