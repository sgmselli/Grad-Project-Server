class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :todos, dependent: :destroy
  has_many :workouts, dependent: :destroy
 
  def generate_jwt
    JWT.encode({ user_id: self.id, exp: 24.hours.from_now.to_i }, Rails.application.secret_key_base)
  end
end
