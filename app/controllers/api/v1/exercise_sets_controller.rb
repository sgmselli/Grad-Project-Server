class Api::V1::ExerciseSetsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_exercise

  def index
    @exercise_sets = @exercise.exercise_sets
    render json: @exercise_sets, status: 200
  end

  def create
    @exercise_set = @exercise.exercise_sets.new(exercise_set_params)
    if @exercise_set.save
      render json: {message: 'successfully created exercise set'}, status: 200
    else
      render json: {error: 'error creating exercise set'}, status: 500
    end
  end

  def update
    @exercise_set = @exercise.exercise_sets.find(params[:id])

    attributes = [:weight, :reps]

    updated_attributes = {}

    attributes.each do |attribute| 
      updated_attributes[attribute.to_s] = params[attribute] if params[attribute].present?
    end

    if @exercise_set.update(updated_attributes)
      render json: {message: 'successfully updated exercise set'}, status: 200
    else
      render json: {error: 'error updating exercise set'}, status: 500
    end
  end

  def destroy
    @exercise_set = @exercise.exercise_sets.find(params[:id])
    if @exercise_set.destroy
      render json: {message: 'successfully deleting exercise set'}, status: 200
    else
      render json: {error: 'error deleting exercise set'}, status: 500
    end
  end

  
  private

  def set_exercise
    @exercise = Exercise.find(params[:exercise_id])
  end

  def exercise_set_params
    params.require(:exercise_set).permit(:weight, :reps)
  end

end
