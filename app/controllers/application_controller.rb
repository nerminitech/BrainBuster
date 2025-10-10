class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Pagy::Backend

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  add_flash_types :success, :warning, :achievement

  protected

  def configure_permitted_parameters
    # Erweitert die erlaubten Felder fuer die Devise-Formulare um unsere Profilangaben.
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username display_name avatar bio role])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username display_name avatar remove_avatar bio role])
  end

  def require_admin!
    # Stoppt alle nicht-administrativen Personen freundlich, bevor eine Aktion ausgefuehrt wird.
    return if current_user&.admin?

    redirect_to root_path, alert: "Du benötigst Administratorrechte." # German message aligning requirement
  end
end
