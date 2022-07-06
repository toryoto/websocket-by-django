class AddNameIndexToTasks < ActiveRecord::Migration[6.0]
  def change
    add_index :tasks, :name, unique: true
  end
end
