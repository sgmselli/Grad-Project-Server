# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.destroy_all
Workout.destroy_all
Exercise.destroy_all


user1 = User.create!(email: 'matt@test2.com', password: '123456' , password_confirmation: '123456')

workout = user1.workouts.create!(name: 'Push Day', completed:false)
workout2 = user1.workouts.create!(name: 'Pull Day', completed:false)
workout3 = user1.workouts.create!(name: 'Leg Day', completed:false)
workout3 = user1.workouts.create!(name: 'Upper Body 🏋️‍♂️', completed:false)

exercise1 = workout.exercises.create(name: 'Bench Press')
workout.exercises.create(name: 'Shoulder Press')
workout.exercises.create(name: 'Cable Fly')
workout.exercises.create(name: 'Lateral Raise')
workout.exercises.create(name: 'Tricep Extension')

exercise1.exercise_sets.create(weight: '80kg', reps: 4)




