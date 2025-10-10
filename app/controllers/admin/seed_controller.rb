class Admin::SeedController < ApplicationController
  before_action :require_admin!

  def create
    Rails.application.load_seed
    redirect_back fallback_location: admin_categories_path, notice: "Seed-Daten wurden erfolgreich geladen." 
  rescue StandardError => e
    redirect_back fallback_location: admin_categories_path, alert: "Seed-Ladevorgang fehlgeschlagen: #{e.message}"
  end
end
