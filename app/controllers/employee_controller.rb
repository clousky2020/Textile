class EmployeeController < ApplicationController
  # before_action :get_employee, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource


  def index
    if params.has_key?(:search) && params[:search] != ""
      @employees = Employee.search(params[:search]).order("work_id").page(params[:page]).per(10)
    elsif params[:order] == "all"
      @employees = Employee.order("work_id").page(params[:page]).per(10)
    else
      @employees = Employee.where("work_status=?", "在职").order("work_id").page(params[:page]).per(10)
    end
  end

  def new
    @employee = Employee.new
  end

  def show
  end

  def edit
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      flash[:success] = "创建成功"
      redirect_to employee_index_url
    else
      flash[:warning] = "#{@employee.errors.full_messages.join(',')}"
      render "employee/new"
    end
  end


  def update
    if @employee.update(employee_params)
      flash[:success] = "成功更新员工信息"
      redirect_to employee_url(@employee)
    else
      flash[:warning] = "#{@employee.errors.full_messages.join(',')}"
      render "employee/edit"
    end
  end

  def destroy
    Employee.delete(@employee)
    redirect_to employee_index_path
  end

  private

  def get_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:name, :gender, :work_id, :work_type, :basic_wage, :minimun_wage, :house_allowance,
                                     :other_allowance, :phone, :bank_card, :work_status, :entry_date, :daparture_date,
                                     :remarks, :role)
  end


end
