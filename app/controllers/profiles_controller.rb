class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
    render partial: "form", locals: { user: @user } if turbo_frame_request?
  end

  def update
    @user = current_user

    respond_to do |format|
      if @user.update(profile_params)
        format.html { redirect_to profile_path, success: "Profil aktualisiert." }
        format.turbo_stream do
          flash.now[:success] = "Profil aktualisiert."
          render turbo_stream: [
            turbo_stream.replace("profile_form", partial: "profiles/form", locals: { user: @user }),
            turbo_stream.replace("profile_overview", partial: "profiles/overview", locals: { user: @user }),
            turbo_stream.replace("user_nav", partial: "layouts/user_nav", locals: { user: @user }),
            turbo_stream.replace("flash_messages", partial: "shared/flash")
          ]
        end
      else
        flash.now[:error] = "Profil konnte nicht aktualisiert werden."
        format.html do
          @user = current_user
          render :show, status: :unprocessable_entity
        end
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("profile_form", partial: "profiles/form", locals: { user: @user }),
            turbo_stream.replace("flash_messages", partial: "shared/flash")
          ], status: :unprocessable_entity
        end
      end
    end
  end

  private

  def profile_params
    params.require(:user).permit(:username, :display_name, :bio, :avatar, :remove_avatar)
  end
end
