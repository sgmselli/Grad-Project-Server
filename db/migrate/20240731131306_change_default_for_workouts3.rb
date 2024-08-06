class ChangeDefaultForWorkouts3 < ActiveRecord::Migration[7.1]
  def change
    change_column_default :workouts, :completed, false

  end
end
