class SettingsController < ApplicationController
  skip_authorization_check

  def index
    @settings = Setting.order(:id).all
  end



  def update
    @setting = Setting.find(params[:id])
    @setting.update_columns(status: params[:setting][:status])
    redirect_to settings_path
  end

end
