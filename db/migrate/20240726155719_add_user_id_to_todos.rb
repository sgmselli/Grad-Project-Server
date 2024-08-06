class AddUserIdToTodos < ActiveRecord::Migration[7.1]
  def change
    add_column :todos, :user_id, :integer
  end
end
