class ProceedController < ApplicationController
  load_and_authorize_resource

  def index
    if params.has_key?(:search) && params.has_key?(:type)
      type = params[:type].split(":")
      @proceeds = Proceed.includes(:sale_customer).sale_customer_search(params[:search]).where("#{type[0]}=?", type[1]).
          references(:sale_customer).order(params[:order]).page(params[:page])
    elsif params.has_key?(:type) && params[:type] != ""
      type = params[:type].split(":")
      @proceeds = Proceed.includes(:sale_customer).where("#{type[0]}=?", type[1]).references(:sale_customer).page(params[:page])
    elsif params.has_key?(:search) && params[:search] != ""
      @proceeds = Proceed.includes(:sale_customer).sale_customer_search(params[:search]).references(:sale_customer).page(params[:page])
    else
      @proceeds = Proceed.order("created_at DESC").page(params[:page])
    end
  end

  def new
    @proceed = Proceed.new
  end

  def edit
    unless !@proceed.check_status
      flash[:warning] = "收款单已审核，不可更改"
      render "proceed/show"
    end
  end

  def show
    unless request.referrer =~ /(new|edit)/
      store_referrer_location
    end
  end

  def create
    @proceed = Proceed.new(proceed_params)
    if @proceed.save
      flash[:success] = "创建成功"
      redirect_to proceed_path(@proceed)
    else
      flash[:warning] = "#{@proceed.errors.full_messages.join(',')}"
      render "proceed/new"
    end
  end

  def update
    if !@proceed.check_status
      if @proceed.update(proceed_params)
        flash[:success] = "成功更新收款单信息"
        redirect_to proceed_path(@proceed.id)
      else
        flash[:warning] = "#{@proceed.errors.full_messages.join(',')}"
        render "proceed/edit"
      end
    else
      flash[:warning] = "收款单已审核，不可更改"
      redirect_to proceed_url(@proceed.id)
    end
  end

  def destroy
    store_referrer_location
    @proceed.order_declare_invalid(current_user)
    # Proceed.delete(@proceed)
    redirect_back_referrer_for proceed_index_path
  end

  def pass_check
    @proceed.pass_check_result(current_user)
    flash[:success] = "#{@proceed.sale_customer.name}的收款单已审核"
    redirect_back_referrer_for proceed_url(@proceed.id)
  end

  private

  def proceed_params
    params.require(:proceed).permit(:name, :user_id, :paper_amount, :actual_amount, :remark, :account_number,
                                    :account_name, :account_from, :picture, :sale_customer_id, :bill_time)
  end

end
