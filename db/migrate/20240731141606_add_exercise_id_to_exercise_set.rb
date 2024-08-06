class AddExerciseIdToExerciseSet < ActiveRecord::Migration[7.1]
  def change
    add_column :exercise_sets, :exercise_id, :integer
  end
end
