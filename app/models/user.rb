class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :workouts, dependent: :destroy
  has_many :exercises, through: :workouts

  def remove_duplicates(arr)
    set = Set.new

    arr.each do |value|
      set.add(value.downcase)
    end

    set.to_a

  end

  def all_workouts
    remove_duplicates(workouts.pluck(:name))
  end

  def all_exercises
    remove_duplicates(exercises.pluck(:name))
  end
 
  def generate_jwt
    JWT.encode({ user_id: self.id, exp: 24.hours.from_now.to_i }, Rails.application.secret_key_base)
  end
end
