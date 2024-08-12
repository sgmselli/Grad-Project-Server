class Workout < ApplicationRecord
  has_many :exercises, dependent: :destroy
  belongs_to :user

  validates :name, presence: true
  validates :date, presence: true
  
  after_initialize :set_default_date, if: :new_record?

  private

  def set_default_date
    self.date ||= Date.today # Sets the date to today's date
  end
  
end


