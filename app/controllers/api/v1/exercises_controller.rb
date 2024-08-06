class Api::V1::ExercisesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_workout

  def index
    @exercises = @workout.exercises
    render json: @exercises, status: 200
  end

  def create
    @exercise = @workout.exercises.new(exercise_params)
    if @exercise.save
      render json: { message: 'exercise created successfully' }, status: 200
    else
      render json: { error: 'error creating exercise' }, status: 500
    end
  end

  def update
    @exercise = @workout.exercises.find(params[:id])

    attributes = [:name]

    updated_attributes = {}

    attributes.each do |attribute| 
      updated_attributes[attribute.to_s] = params[attribute] if params[attribute].present?
    end

    if @exercise.update(updated_attributes)
      render json: { message: 'exercise updated successfully' }, status: 200
    else
      render json: { error: 'error updating exercise' }, status: 500
    end

  end

  def destroy
    @exercise = @workout.exercises.find(params[:id])
    if @exercise
      @exercise.destroy
      render json: { message: 'exercise successfully destroyed'}, status: 200
    else
      render json: { error: 'error deleting exercise'}, status: 500
    end
  end

  private

  def set_workout
    @workout = Workout.find(params[:workout_id])
  end

  def exercise_params
    params.require(:exercise).permit(:name)
  end

end
