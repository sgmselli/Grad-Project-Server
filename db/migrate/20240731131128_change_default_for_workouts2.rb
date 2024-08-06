class ChangeDefaultForWorkouts2 < ActiveRecord::Migration[7.1]
  def change
    change_column_default :workouts, :completed, true

  end
end
