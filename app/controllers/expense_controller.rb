class ExpenseController < ApplicationController
  load_and_authorize_resource

  def index
    if params.has_key?(:search) && params.has_key?(:type)
      type = params[:type].split(":")
      @expenses = Expense.left_outer_joins(:purchase_suppliers).search(params[:search]).where("#{type[0]}=?", type[1]).
          references(:purchase_suppliers).order(params[:order]).page(params[:page])
    elsif params.has_key?(:type) && params[:type] != ""
      type = params[:type].split(":")
      @expenses = Expense.left_outer_joins(:purchase_suppliers).where("#{type[0]}=?", type[1]).references(:purchase_suppliers).order("created_at DESC").page(params[:page])
    elsif params.has_key?(:search) && params[:search] != ""
      @expenses = Expense.left_outer_joins(:purchase_suppliers).search(params[:search]).references(:purchase_suppliers).order("created_at DESC").page(params[:page])
    else
      @expenses = Expense.order("created_at DESC").page(params[:page])
    end
  end

  def new
    @expense = Expense.new
  end

  def edit
    if !@expense.check_status
      @expense
    else
      flash[:warning] = "收款单已审核，不可更改"
      render "expense/show"
    end
  end

  def show
    unless request.referrer =~ /(new|edit)/
      store_referrer_location
    end
  end

  def create
    @expense = Expense.new(expense_params)
    if @expense.save
      @expense.build_purchase_supplier
      flash[:success] = "创建成功"
      redirect_to expense_path(@expense)
    else
      flash[:warning] = "#{@expense.errors.full_messages.join(',')}"
      render "expense/new"
    end
  end

  def update
    if !@expense.check_status
      if @expense.update(expense_params)
        @expense.build_purchase_supplier
        flash[:success] = "成功更新付款单信息"
        redirect_to expense_path(@expense.id)
      else
        flash[:warning] = "#{@expense.errors.full_messages.join(',')}"
        render "expense/edit"
      end
    else
      flash[:warning] = "付款单已审核，不可更改"
      redirect_to expense_url(@expense.id)
    end
  end

  def destroy
    store_referrer_location
    @expense.order_declare_invalid(current_user)
    # Expense.delete(@expense)
    redirect_back_referrer_for expense_index_path
  end

  def pass_check
    @expense.pass_check_result(current_user)
    flash[:success] = "#{@expense.counterparty}的付款单已审核"
    redirect_back_referrer_for(expense_url(@expense.id))
  end

  def pass_reimburse
    @expense.pass_reimburse_expense
    flash[:success] = "#{@expense.counterparty}的付款单已通过报销"
    redirect_back_referrer_for(expense_url(@expense.id))
  end

  def get_expense_type
    @expense = Expense.search_expense_type(params[:term]).map(&:expense_type).uniq
    render json: @expense
  end

  private

  def expense_params
    params.require(:expense).permit(:expense_type, :counterparty, :user_id, :paper_amount, :actual_amount, :remark,
                                    :account_number, :account_name, :account_from, :picture, :need_reimburse, :bill_time)
  end

end
