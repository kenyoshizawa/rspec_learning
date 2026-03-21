class TasksController < ApplicationController
  before_action :set_project
  before_action :project_owner?
  before_action :set_task, only: %i[ show edit update destroy toggle ]

  def show
  end

  def new
    @task = @project.tasks.build
  end

  def create
    @task = @project.tasks.new(task_params)

    if @task.save
      redirect_to @project, status: :see_other, notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to @project, notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @task.destroy
      redirect_to @project, status: :see_other, notice: "Task was successfully destroyed."
    else
      redirect_to project_url(@project), status: :see_other, alert: "Task could not be destroyed."
    end
  end

  def toggle
    @task.update(completed: !@task.completed)
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :completed, :project_id)
  end
end
