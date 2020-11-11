class ChangeMachinesController < ApplicationController
  # before_action :get_change_machine, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource


  def index
    if params.has_key?(:search) && params[:search] != ""
      @change_machines = ChangeMachine.search(params[:search]).order("change_date DESC").page(params[:page])
    elsif params.has_key?(:type) && params[:type] != ""
      type = params[:type].split(":")
      @change_machines = ChangeMachine.where("#{type[0]}=?", type[1]).order("created_at DESC").page(params[:page])
    else
      @change_machines = ChangeMachine.order("is_settle,created_at ").page(params[:page])
    end
  end

  def new
    @change_machine = ChangeMachine.new
  end

  def show
  end

  def edit
  end

  def create
    @change_machine = ChangeMachine.new(change_machine_params)
    if @change_machine.save
      flash[:success] = "创建成功"
      redirect_to change_machines_url
    else
      flash[:warning] = "#{@change_machine.errors.full_messages.join(',')}"
      render "change_machine/new"
    end
  end


  def update
    if @change_machine.update(change_machine_params)
      flash[:success] = "成功更新改机信息"
      redirect_to change_machine_url(@change_machine)
    else
      flash[:warning] = "#{@change_machine.errors.full_messages.join(',')}"
      render "change_machine/edit"
    end
  end

  def destroy
    ChangeMachine.delete(@change_machine)
    redirect_to change_machines_path
  end

  def pass_settle
    @change_machine.update(is_settle: true)

    # 结清后新建一个付款单
    Expense.create(counterparty: @change_machine.change_person, paper_amount: @change_machine.price, user_id: current_user.id,
                   actual_amount: @change_machine.price, bill_time: Time.now.localtime, expense_type: "改机",
                   remark: ("#{@change_machine.machine_id}号机器要改#{@change_machine.machine_type}\n#{@change_machine.remark}"))

    redirect_to change_machines_path
  end

  private

  def get_change_machine
    @change_machine = ChangeMachine.find(params[:id])
  end

  def change_machine_params
    params.require(:change_machine).permit(:change_person, :contacts, :machine_id, :machine_type, :price, :change_date,
                                           :change_to_specification, :remark)
  end

end
