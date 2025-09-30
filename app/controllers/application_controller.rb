class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  add_flash_types :success, :warning

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username display_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username display_name])
  end

  def require_admin!
    return if current_user&.admin?

    redirect_to root_path, alert: "Du benötigst Administratorrechte." # German message aligning requirement
  end
end
