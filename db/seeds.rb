require 'creek'

creek = Creek::Book.new "顾丰.xlsm"
# 导入员工信息
creek.sheets.each do |sheet|
  if sheet.name == '员工信息'
    sheet.rows_with_meta_data.each do |row|
      n = row['r']
      if n != "1"
        cells = row['cells']
        Employee.create(name: cells["B#{n}"], gender: cells["C#{n}"], work_type: cells["D#{n}"], work_id: cells["A#{n}"],
                        basic_wage: cells["E#{n}"], minimun_wage: cells["F#{n}"], house_allowance: cells["H#{n}"],
                        other_allowance: cells["I#{n}"], phone: cells["J#{n}"], bank_card: cells["K#{n}"],
                        work_status: cells["M#{n}"], entry_date: cells["N#{n}"], daparture_date: cells["O#{n}"])

      end
    end
  end
end


#新建账户
users = ['李文强', '王朝辉', '姚一夫', '顾晁诚', '顾乐峰', '赵海英']
n = 1
users.each do |name|
  user = User.new(name: name, password: "123456", email: "123456#{n}@qq.com")

  user.save
  if user.save
    # 新建一个受管理的本地仓库
    user.create_repo(name: "本地#{n}号", description: "初始设定的仓库,受#{user.name}管理")
    n += 1
  end
end

# 新建一个管理员角色，并赋予第一个用户
role = Role.new
role.name = "管理员"
role.permissions.super = true
role.save
user = User.first
user.roles << role
user.save

# 添加默认参数配置
params_list = {
    "权限认证": "开启后全系统具有认证体系",
    "采购账单自动审核": "有财务权限者录入的采购订单自动完成审核",
    "销售账单自动审核": "有仓管权限者录入的销售订单自动完成审核"
}
params_list.each do |key, value|
  p "参数录入：#{key}=>#{value}"
  Param.find_or_create_by(name: key, description: value, status: false)
end

creek.sheets.each do |sheet|
  if sheet.name == '交易单'
    sheet.rows_with_meta_data.each do |row|
      n = row['r']
      if n != "1"
        cells = row['cells']
        #记录供应商名字
        purchase_supplier = PurchaseSupplier.find_or_create_by(name: cells["E#{n}"])
        if !cells["B#{n}"].blank? && !cells["C#{n}"].blank?
          #创建原材料目录
          material = Material.find_or_create_by(name: cells["B#{n}"], specification: cells["C#{n}"], purchase_supplier_id: purchase_supplier.id, measuring_unit: "包/箱")
          if material
            user = User.find(rand(1..3))
            repo = Repo.find(rand(1..3))
            #导入以前的交易单
            PurchaseOrder.find_or_create_by(batch_number: cells["D#{n}"], weight: cells["F#{n}"], number: cells["G#{n}"],
                                            measuring_unit: "包/箱", repo_id: repo.id, user_id: user.id,
                                            tax_rate: cells["J#{n}"] || 0, deposit: cells["L#{n}"], freight: cells["M#{n}"],
                                            description: cells["N#{n}"], bill_time: cells["A#{n}"], price: cells["I#{n}"],
                                            material_id: material.id, purchase_supplier_id: purchase_supplier.id,)
          end
        end
      end
    end
  end
  if sheet.name == '型号转数表设定'
    sheet.rows_with_meta_data.each do |row|
      n = row['r']
      if n != "1"
        cells = row['cells']
        #创建产品目录
        Product.find_or_create_by(name: cells["B#{n}"], specification: cells["A#{n}"], measuring_unit: "匹",
                                  turns_number: cells["C#{n}"], labor_cost: cells["E#{n}"], remarks: cells["F#{n}"])
      end
    end
  end
  if sheet.name == '出货'
    sheet.rows_with_meta_data.each do |row|
      n = row['r']
      if n != "1"
        user = User.find(rand(1..3))
        repo = Repo.find(rand(1..3))
        cells = row['cells']
        # 创建客户名称
        sale_customer = SaleCustomer.find_or_create_by(name: cells["C#{n}"])
        #创建产品目录
        product = Product.find_or_create_by(name: cells["B#{n}"], specification: cells["D#{n}"], measuring_unit: "匹")
        #导入以前的出货单
        SaleOrder.create(weight: cells["E#{n}"], number: cells["F#{n}"], measuring_unit: "匹", tax_rate: 0, freight: 0,
                         price: cells["G#{n}"], description: cells["N#{n}"], bill_time: cells["A#{n}"],
                         sale_customer_id: sale_customer.id, product_id: product.id, repo_id: repo.id, user_id: user.id)


      end
    end
  end

  if sheet.name == '收入详细'
    sheet.rows_with_meta_data.each do |row|
      n = row['r']
      if n != "1" && n != "2"
        user = User.find(rand(1..3))
        cells = row['cells']
        #创建客户目录
        sale_customer = SaleCustomer.find_or_create_by(name: cells["B#{n}"])
        Proceed.find_or_create_by(sale_customer_id: sale_customer.id, user_id: user.id,
                                  paper_amount: cells["C#{n}"], actual_amount: cells["D#{n}"],
                                  remark: cells["E#{n}"], bill_time: cells["A#{n}"])
      end
    end
  end


  if sheet.name == '支出详细'
    sheet.rows_with_meta_data.each do |row|
      n = row['r']
      if n != "1" && n != "2" && row['cells']["B#{n}"] != nil
        user = User.find(rand(1..3))
        cells = row['cells']

        #查询供应商名单
        purchase_supplier = PurchaseSupplier.find_by(name: cells["B#{n}"])
        if purchase_supplier
          type = "货款"
        elsif cells["B#{n}"].include? "工资"
          type = "工资"
        elsif cells["B#{n}"].include? "改机"
          type = "改机"
        else
          type = "日常消耗"
        end
        expose = Expense.find_or_create_by(counterparty: cells["B#{n}"], expense_type: type, user_id: user.id,
                                           paper_amount: cells["C#{n}"], actual_amount: cells["D#{n}"],
                                           account_number: cells["F#{n}"], account_name: cells["E#{n}"],
                                           account_from: cells["G#{n}"], remark: cells["H#{n}"], bill_time: cells["A#{n}"])
        if type == "货款"
          purchase_supplier.expenses << expose
          purchase_supplier.save
        end
      end
    end
  end

end

