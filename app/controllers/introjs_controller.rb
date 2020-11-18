class IntrojsController < ApplicationController
  def create
    Intro.find_or_create_by(controller_name: params[:controller_name], action_name: params[:action_name],
                            tour_name: params[:tour_name], creator_id: params[:creator_id])

  end

  def destroy
    store_referrer_location
    Intro.delete(controller_name: params[:controller_name], action_name: params[:action_name],
                 tour_name: params[:tour_name], creator_id: params[:creator_id])
    redirect_back_referrer_for root_url
  end

  def find_attribute
    date = Intro.find_by(controller_name: params[:controller_name], action_name: params[:action_name],
                         tour_name: params[:tour_name], creator_id: params[:creator_id])
    render json: date
  end
end
