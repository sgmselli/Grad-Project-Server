class Api::V1::WorkoutsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def index
    @workouts = current_user.all_workouts
    render json: @workouts, status: 200
  end

  def completed
    @completed_workouts = current_user.workouts.where(completed: true)
    render json: @completed_workouts, status: 200
  end

  def incomplete
    @incomplete_workouts = current_user.workouts.where(completed: false)
    render json:  @incomplete_workouts, status: 200
  end

  def create
    @workout = current_user.workouts.new(workout_params)
    if @workout.save
      render json: @workout, status: 200
    else
      render json: @workout.errors, status: 500
    end
  end

  def update
    @workout = Workout.find(params[:id])
    attributes = [:name, :completed]

    updated_attributes = {}

    attributes.each do |attribute| 
      updated_attributes[attribute.to_s] = params['0'][attribute] if params["0"][attribute].present?
    end
    
    if @workout.update(updated_attributes)
      render json: {message: 'updated workout successfully'}, status:200
    else
      render json: { error: 'error updating workout'}, status:500
    end
  end

  def destroy
    @workout = Workout.find(params[:id])
    if @workout
      @workout.destroy
      render json: { message: 'deleted workout successfully' }, status: 200
    else
      render json: { error: 'error deleting workout' }, status: 500
    end
  end

  private

  def workout_params
    params.require(:workout).permit(:name, :completed, :date)
  end

end
