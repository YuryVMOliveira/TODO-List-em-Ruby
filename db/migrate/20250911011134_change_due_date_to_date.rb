class ChangeDueDateToDate < ActiveRecord::Migration[8.0]
  def change
    change_column :tasks, :due_date, :date
  end
end