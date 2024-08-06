class AddWorkoutIdToExercises < ActiveRecord::Migration[7.1]
  def change
    add_column :exercises, :workout_id, :integer
  end
end
