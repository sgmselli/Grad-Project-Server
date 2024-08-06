class Workout < ApplicationRecord
  has_many :exercises, dependent: :destroy
  belongs_to :user

  validates :name, presence: true
  # validates :completed, presence: true

  # after_initialize :set_defaults

  # def set_defaults
  #   self.completed = false
  # end
end


