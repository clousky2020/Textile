class ParamsController < ApplicationController
  skip_authorization_check

  def index
    @params = Param.order(:id).all
  end



  def update
    @param = Param.find(params[:id])
    @param.update_columns(status: params[:param][:status])
    redirect_to params_path
  end

end
