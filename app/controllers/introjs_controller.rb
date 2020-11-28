class IntrojsController < ApplicationController
  def create
    unless Setting.setting_status("新手引导")
      Intro.find_or_create_by(controller_name: params[:controller_name], action_name: params[:action_name],
                              tour_name: params[:tour_name], user_id: params[:user_id])
    end
  end

  def destroy
    store_referrer_location
    Intro.delete(controller_name: params[:controller_name], action_name: params[:action_name],
                 tour_name: params[:tour_name], user_id: params[:user_id])
    redirect_back_referrer_for root_url
  end

  def find_attribute
    date = Intro.find_by(controller_name: params[:controller_name], action_name: params[:action_name],
                         tour_name: params[:tour_name], user_id: params[:user_id])
    render json: date
  end
end
