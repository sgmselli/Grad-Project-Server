
class Api::V1::TodosController < ApplicationController

  before_action :authenticate_user!
  before_action :set_todo

  def index
    @todos = current_user.todos
    render json: @todos
  end

  def show
    @todo = @user.todos.find(params[:id])
    render json: @todo
  end

  def create
    @todo = @user.todos.new(valid_params)
    if @todo.save
      render json: @todo, status: 200
    else
      render json: @todo.errors, status: 500
    end
  end

  def update
    @todo = Todo.find(params[:id])
    if @todo
      @todo.update(valid_params)
      render json: {message: 'updated todo successfully'}, status:200
    else
      render json: {error: 'was not able to update todo'}, status:500
    end
  end

  def destroy
    @todo = Todo.find(params[:id])
    if @todo
      @todo.destroy
      render json: {message: 'destroyed todo successfully'}, status: 200
    else
      render json: {error: 'was not able to destroy todo'}, status: 500
    end
  end
  
  private 

  def valid_params
    params.require(:todo).permit(:title)
  end


  def set_todo
    @todo = current_user.todos.all
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Todo not found' }, status: :not_found
  end

end
