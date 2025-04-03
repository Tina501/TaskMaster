class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy, :toggle, :complete]

  def index
    @tasks = current_user.tasks

    case params[:filter]
    when 'completed'
      @tasks = @tasks.where(completed: true)
    when 'pending'
      @tasks = @tasks.where(completed: false)
    end

    @pagy, @tasks = pagy(@tasks.order(created_at: :desc))
  end

  def today
    @tasks = current_user.tasks.where("deadline >= ? AND deadline <= ?", Time.zone.today.beginning_of_day, Time.zone.today.end_of_day)
  end

  def new
    @task = current_user.tasks.build
    @task.sub_tasks.build # Build an empty subtask
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      redirect_to tasks_path, notice: 'Task was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'Task was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully deleted.'
  end

  def toggle
    if @task.completed?
      @task.update(completed: false, completed_at: nil)
    else
      @task.update(completed: true, completed_at: Time.current)
    end
    redirect_to tasks_path
  end

  def complete
    @task.mark_as_completed!
    redirect_to tasks_path, notice: 'Task was successfully completed.'
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(
      :title,
      :description,
      :deadline,
      :priority,
      sub_tasks_attributes: [:id, :title, :description, :deadline, :_destroy],
      collaborations_attributes: [:id, :user_id, :_destroy]
    )
  end
end
