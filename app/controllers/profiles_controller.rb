class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    redirect_to profile_path
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      flash[:success] = "Profil aktualisiert."
      redirect_to profile_path
    else
      flash.now[:error] = "Profil konnte nicht aktualisiert werden."
      render :show, status: 422
    end
  end

  private

  def profile_params
    params.require(:user).permit(:username, :display_name, :bio, :avatar, :remove_avatar)
  end
end
