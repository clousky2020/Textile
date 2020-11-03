class ParamController < ApplicationController
  skip_authorization_check

  def index
    @params = Param.order(:id).all
  end

  def edit

  end

  def update
    @param = Param.find(params[:id])
    @param.update_columns(status: params[:param][:status])
    redirect_to param_index_path
  end

end
