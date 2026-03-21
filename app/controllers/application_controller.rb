class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def set_project
    @project = Project.find(params[:project_id])
  end

  def project_owner?
    unless  current_user == @project.owner
      redirect_to root_path, alert: t("errors.access_denied.project")
    end
  end

  def configure_permitted_parameters
    %i[ sign_up ].each do |action|
      devise_parameter_sanitizer.permit(action, keys: [ :first_name, :last_name ])
    end
  end
end
