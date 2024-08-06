class AddNameAndCompletedToWorkouts < ActiveRecord::Migration[7.1]
  def change
    add_column :workouts, :name, :string
    add_column :workouts, :completed, :boolean, default: false
  end
end
