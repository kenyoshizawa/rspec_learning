class NotesController < ApplicationController
  before_action :set_project
  before_action :project_owner?
  before_action :set_note, only: %i[ edit update destroy ]

  def index
  end

  def new
    @note = @project.notes.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end
end
