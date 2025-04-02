class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :complete, :destroy]

  def index
    @tasks = current_user.tasks
  end

  def today
    @tasks = current_user.tasks.where("deadline >= ? AND deadline <= ?", Time.zone.today.beginning_of_day, Time.zone.today.end_of_day)
  end

  def new
    @task = Task.new
    @task.collaborations.build
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: "Task was successfully created!"
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Task updated successfully"
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "Task deleted successfully"
  end

  def complete
    @task.update(completed: true)
    redirect_to tasks_path, notice: "Task marked as completed"
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :deadline, :priority, :completed, collaborations_attributes: [:id, :user_id, :_destroy])
  end
end
