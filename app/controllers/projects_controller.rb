class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy complete ]
  before_action :project_owner?, except: %i[ index new create ]

  def index
    @projects = current_user.projects
  end

  def show
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.new(project_params)

    if @project.save
      redirect_to project_url(@project), status: :see_other, notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to project_url(@project), status: :see_other, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @project.destroy
      redirect_to projects_url, status: :see_other, notice: t(".success")
    else
      redirect_to project_url(@project), status: :see_other, alert: t(".fail")
    end
  end

  def complete
    if @project.update(completed: true)
      redirect_to @project, status: :see_other, notice: t(".success")
    else
      redirect_to @project, status: :see_other, alert: t(".fail")
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :due_on)
  end
end
