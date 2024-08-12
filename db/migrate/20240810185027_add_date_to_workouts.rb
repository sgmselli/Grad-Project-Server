class AddDateToWorkouts < ActiveRecord::Migration[7.1]
  def change
    add_column :workouts, :date, :date
  end
end
