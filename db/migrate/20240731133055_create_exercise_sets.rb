class CreateExerciseSets < ActiveRecord::Migration[7.1]
  def change
    create_table :exercise_sets do |t|
      t.float :weight
      t.integer :reps

      t.timestamps
    end
  end
end
