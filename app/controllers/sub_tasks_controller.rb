class SubTasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task
  before_action :set_sub_task, only: [:show, :edit, :update, :destroy, :toggle]

  def create
    @sub_task = @task.sub_tasks.build(sub_task_params)

    if @sub_task.save
      redirect_to @task, notice: 'Subtask was successfully created.'
    else
      redirect_to @task, alert: 'Error creating subtask.'
    end
  end

  def show
    render turbo_stream: turbo_stream.update("sub_task_details", partial: "sub_tasks/details", locals: { sub_task: @sub_task })
  end

  def edit
    render turbo_stream: turbo_stream.update("sub_task_#{@sub_task.id}", partial: "sub_tasks/form", locals: { sub_task: @sub_task })
  end

  def update
    if @sub_task.update(sub_task_params)
      redirect_to @task, notice: 'Subtask was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @sub_task.destroy
    redirect_to @task, notice: 'Subtask was successfully deleted.'
  end

  def toggle
    @sub_task.update(completed: !@sub_task.completed)
    respond_to do |format|
      format.html { redirect_to tasks_path }
      format.turbo_stream
    end
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:task_id])
  end

  def set_sub_task
    @sub_task = @task.sub_tasks.find(params[:id])
  end

  def sub_task_params
    params.require(:sub_task).permit(:title, :description, :deadline)
  end
end
