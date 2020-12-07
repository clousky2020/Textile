require 'creek'


p '新建账户'
users = ['管理员', '采购员', '销售员', '财务', '车间主任']
n = 1
users.each do |name|
  user = User.new(name: name, password: "123456", email: "1111#{n}@qq.com")
  user.save
  n += 1
end

p "设置目前所有的机台信息"
(1..20).each do |n|
  Machine.create(specification: "84路", machine_id: n, company: "精镁")
end
(21..27).each do |n|
  Machine.create(specification: "72路", machine_id: n, company: "泉州恒毅机械")
end


p '新建角色'
roles = ['管理员', '采购员', '销售员', '财务', '车间主任']
descriptions = {"管理员": "拥有本系统所有权限，对比其他角色拥有新建角色权限的功能！小心不要把自己的超级权限给删掉了！",
                "采购员": "新采购的原料填写采购单，代买的物品填写付款单，记得打上报销的勾，也能填写收款单。编辑原料信息。查看所有的采购单。",
                "销售员": "对销售的货物填写销售单，代买的物品填写付款单，记得打上报销的勾。编辑产品的信息，查看所有的销售单。",
                "财务": "主要工作是审核采购单、销售单、付款单、收款单，使其记入系统计算，必要时可以作废以上单据。在对账日导出供应商和客户的对账单。更新供应商和客户的资料。",
                "车间主任": "编辑员工资料记录，对新采购的原料填写采购单，销售的货物填写销售单，代买的物品填写付款单，记得打上报销的勾。编辑新的产品信息。查看所有的销售单和采购单。编辑仓库信息。"}

Permissions = {"管理员": {"super" => "1"},
               "采购员": {"super" => "0", "users" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "0", "read_my_own" => "1", "update_my_own" => "1", "reset" => "0", "lock" => "0"}, "roles" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "0"}, "change_machines" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "1", "pass_settle" => "0"}, "employee" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "1"}, "repos" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "1"}, "products" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "1"}, "materials" => {"create" => "0", "destroy" => "1", "update" => "1", "read" => "1"}, "sale_customers" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "1", "export" => "0"}, "sale_orders" => {"create" => "0", "destroy" => "0", "update" => "0", "pass_check" => "0", "read" => "0", "update_my_own" => "1", "destroy_my_own" => "1"}, "purchase_orders" => {"create" => "1", "destroy" => "1", "update" => "1", "pass_check" => "0", "read" => "1", "update_my_own" => "1", "destroy_my_own" => "1"}, "purchase_suppliers" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "1", "export" => "0"}, "params" => {"update" => "0", "read" => "1"}, "expenses" => {"create" => "1", "destroy" => "0", "update" => "0", "pass_check" => "0", "pass_reimburse" => "0", "read" => "1", "update_my_own" => "1", "destroy_my_own" => "1"}, "proceeds" => {"create" => "1", "destroy" => "0", "update" => "0", "pass_check" => "0", "read" => "1", "update_my_own" => "1", "destroy_my_own" => "1"}, "comments" => {"create" => "1", "destroy" => "0", "update" => "0", "take_top" => "0", "read" => "1", "update_my_own" => "1", "destroy_my_own" => "1"}},
               "销售员": {"super" => "0", "users" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "0", "read_my_own" => "1", "update_my_own" => "1", "reset" => "0", "lock" => "0"}, "roles" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "0"}, "change_machines" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "1", "pass_settle" => "0"}, "employee" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "1"}, "repos" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "1"}, "products" => {"create" => "0", "destroy" => "0", "update" => "1", "read" => "1"}, "materials" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "1"}, "sale_customers" => {"create" => "0", "destroy" => "0", "update" => "1", "read" => "1", "export" => "0"}, "sale_orders" => {"create" => "1", "destroy" => "1", "update" => "1", "pass_check" => "0", "read" => "1", "update_my_own" => "1", "destroy_my_own" => "1"}, "purchase_orders" => {"create" => "0", "destroy" => "0", "update" => "0", "pass_check" => "0", "read" => "0", "update_my_own" => "1", "destroy_my_own" => "1"}, "purchase_suppliers" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "1", "export" => "0"}, "params" => {"update" => "0", "read" => "1"}, "expenses" => {"create" => "1", "destroy" => "0", "update" => "0", "pass_check" => "0", "pass_reimburse" => "0", "read" => "1", "update_my_own" => "1", "destroy_my_own" => "1"}, "proceeds" => {"create" => "1", "destroy" => "0", "update" => "0", "pass_check" => "0", "read" => "1", "update_my_own" => "1", "destroy_my_own" => "1"}, "comments" => {"create" => "1", "destroy" => "0", "update" => "0", "take_top" => "0", "read" => "1", "update_my_own" => "1", "destroy_my_own" => "1"}},
               "财务": {"super" => "0", "users" => {"create" => "0", "destroy" => "0", "update" => "1", "read" => "1", "read_my_own" => "1", "update_my_own" => "1", "reset" => "0", "lock" => "0"}, "roles" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "0"}, "change_machines" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "1", "pass_settle" => "0"}, "employee" => {"create" => "1", "destroy" => "0", "update" => "1", "read" => "1"}, "repos" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "1"}, "products" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "1"}, "materials" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "1"}, "sale_customers" => {"create" => "0", "destroy" => "0", "update" => "1", "read" => "1", "export" => "1"}, "sale_orders" => {"create" => "1", "destroy" => "1", "update" => "1", "pass_check" => "1", "read" => "1", "update_my_own" => "1", "destroy_my_own" => "1"}, "purchase_orders" => {"create" => "1", "destroy" => "1", "update" => "1", "pass_check" => "1", "read" => "1", "update_my_own" => "1", "destroy_my_own" => "1"}, "purchase_suppliers" => {"create" => "0", "destroy" => "0", "update" => "1", "read" => "1", "export" => "1"}, "params" => {"update" => "0", "read" => "1"}, "expenses" => {"create" => "1", "destroy" => "1", "update" => "1", "pass_check" => "1", "pass_reimburse" => "1", "read" => "1", "update_my_own" => "1", "destroy_my_own" => "1"}, "proceeds" => {"create" => "1", "destroy" => "1", "update" => "1", "pass_check" => "1", "read" => "1", "update_my_own" => "1", "destroy_my_own" => "1"}, "comments" => {"create" => "1", "destroy" => "0", "update" => "0", "take_top" => "0", "read" => "1", "update_my_own" => "1", "destroy_my_own" => "1"}},
               "车间主任": {"super" => "0", "users" => {"create" => "0", "destroy" => "0", "update" => "1", "read" => "0", "read_my_own" => "1", "update_my_own" => "1", "reset" => "0", "lock" => "0"}, "roles" => {"create" => "0", "destroy" => "0", "update" => "0", "read" => "0"}, "change_machines" => {"create" => "1", "destroy" => "1", "update" => "1", "read" => "1", "pass_settle" => "1"}, "employee" => {"create" => "1", "destroy" => "0", "update" => "1", "read" => "1"}, "repos" => {"create" => "1", "destroy" => "1", "update" => "1", "read" => "1"}, "products" => {"create" => "1", "destroy" => "1", "update" => "1", "read" => "1"}, "materials" => {"create" => "0", "destroy" => "0", "update" => "1", "read" => "1"}, "sale_customers" => {"create" => "0", "destroy" => "0", "update" => "1", "read" => "1", "export" => "0"}, "sale_orders" => {"create" => "1", "destroy" => "1", "update" => "1", "pass_check" => "0", "read" => "1", "update_my_own" => "1", "destroy_my_own" => "1"}, "purchase_orders" => {"create" => "1", "destroy" => "1", "update" => "1", "pass_check" => "0", "read" => "1", "update_my_own" => "1", "destroy_my_own" => "1"}, "purchase_suppliers" => {"create" => "0", "destroy" => "0", "update" => "1", "read" => "1", "export" => "0"}, "params" => {"update" => "0", "read" => "1"}, "expenses" => {"create" => "1", "destroy" => "0", "update" => "0", "pass_check" => "0", "pass_reimburse" => "0", "read" => "1", "update_my_own" => "1", "destroy_my_own" => "1"}, "proceeds" => {"create" => "1", "destroy" => "0", "update" => "0", "pass_check" => "0", "read" => "1", "update_my_own" => "1", "destroy_my_own" => "1"}, "comments" => {"create" => "1", "destroy" => "0", "update" => "0", "take_top" => "0", "read" => "1", "update_my_own" => "1", "destroy_my_own" => "1"}}
}

roles.each do |name|
  role = Role.find_or_create_by(name: name)
  role.description = descriptions[name.to_sym]
  if role.name == "管理员"
    role.permissions.super = true
  end
  role.save
  user = User.find_by(name: name)
  if user.roles.blank?
    user.roles << role
  end
  user.save
end

p '新建一个本地仓库'
repo = Repo.find_or_create_by(name: "本厂", description: "初始设定的仓库", address: "工业园")
repo.user = User.first
repo.save


p '添加默认参数配置'
setting_list = {
    "采购账单自动审核": "有审核权限者录入的采购订单自动完成审核",
    "销售账单自动审核": "有审核权限者录入的销售订单自动完成审核",
    "连续审核": "如有未审核的相同公司的订单，在审核后直接跳转到未审核的订单界面",
    "新手引导": "开启后即使完成了新手引导，下次进来还会有新手引导"
}
setting_list.each do |key, value|
  p "参数录入：#{key}=>#{value}"
  Setting.find_or_create_by(name: key, description: value, status: false)
end
p '检查是否有初始资料'
if File.exist?("初始资料.xlsm")
  creek = Creek::Book.new "初始资料.xlsm"

  creek.sheets.each do |sheet|
    if sheet.name == '员工信息'
      p '导入员工信息'
      sheet.rows_with_meta_data.each do |row|
        n = row['r']
        if n != "1"
          cells = row['cells']
          employee = Employee.find_or_create_by(name: cells["B#{n}"], gender: cells["C#{n}"], work_type: cells["D#{n}"], work_id: cells["A#{n}"],
                                                basic_wage: cells["E#{n}"], minimun_wage: cells["F#{n}"], house_allowance: cells["H#{n}"],
                                                other_allowance: cells["I#{n}"], phone: cells["J#{n}"], bank_card: cells["K#{n}"],
                                                entry_date: cells["N#{n}"], daparture_date: cells["O#{n}"])
          employee.status = false if employee.daparture_date
          employee.save
        end
      end
    end
  end

  creek.sheets.each do |sheet|
    if sheet.name == '原始产量'
      p '导入原始产量'
      sheet.rows_with_meta_data.each do |row|
        n = row['r']
        if n != "1"
          cells = row['cells']
          if cells["E#{n}"].to_f < 99.9
            product = Product.find_by(specification: cells["B#{n}"])
            Output.create(output_date: cells["A#{n}"], product_id: product.id, machine_id: cells["C#{n}"],
                           work_id: cells["D#{n}"], weight: cells["E#{n}"])

          end
        end
      end
    end

    # if sheet.name == '交易单'
    #   p '导入采购单'
    #   sheet.rows_with_meta_data.each do |row|
    #     n = row['r']
    #     if n != "1"
    #       cells = row['cells']
    #       #记录供应商名字
    #       purchase_supplier = PurchaseSupplier.find_or_create_by(name: cells["E#{n}"])
    #       if !cells["B#{n}"].blank? && !cells["C#{n}"].blank?
    #         #创建原材料目录
    #         material = Material.find_or_create_by(name: cells["B#{n}"], specification: cells["C#{n}"],
    #                                               purchase_supplier: purchase_supplier, measuring_unit: "包/箱")
    #         if material
    #           user = User.find(rand(1..3))
    #           repo = Repo.first
    #           #导入以前的交易单
    #           PurchaseOrder.find_or_create_by(batch_number: cells["D#{n}"], weight: cells["F#{n}"], number: cells["G#{n}"],
    #                                           measuring_unit: "包/箱", repo_id: repo.id, user_id: user.id,
    #                                           tax_rate: cells["J#{n}"] || 0, deposit: cells["L#{n}"], freight: cells["M#{n}"],
    #                                           description: cells["N#{n}"], bill_time: cells["A#{n}"], price: cells["I#{n}"],
    #                                           material_id: material.id, purchase_supplier_id: purchase_supplier.id,)
    #         end
    #       end
    #     end
    #   end
    # end

    if sheet.name == '型号转数表设定'
      p '导入型号转数表设定'
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

    # if sheet.name == '改机'
    #   p '导入改机信息'
    #   sheet.rows_with_meta_data.each do |row|
    #     n = row['r']
    #     if n != "1"
    #       cells = row['cells']
    #       change_machine = ChangeMachine.new(change_person: cells["D#{n}"], contacts: cells["E#{n}"], price: cells["C#{n}"],
    #                                          machine_id: cells["B#{n}"], machine_type: cells["F#{n}"], remark: cells["H#{n}"],
    #                                          change_date: cells["A#{n}"], change_to_specification: cells["G#{n}"])
    #       if cells["I#{n}"] == "已结清"
    #         change_machine.is_settle = true
    #       end
    #       change_machine.save
    #     end
    #   end
    # end

    # if sheet.name == '出货'
    #   p '导入出货'
    #   sheet.rows_with_meta_data.each do |row|
    #     n = row['r']
    #     if n != "1"
    #       user = User.find(rand(1..3))
    #       repo = Repo.first
    #       cells = row['cells']
    #       # 创建客户名称
    #       sale_customer = SaleCustomer.find_or_create_by(name: cells["C#{n}"])
    #       #创建产品目录
    #       product = Product.find_or_create_by(name: cells["B#{n}"], specification: cells["D#{n}"], measuring_unit: "匹")
    #       #导入以前的出货单
    #       SaleOrder.create(weight: cells["E#{n}"], number: cells["F#{n}"], measuring_unit: "匹", tax_rate: 0, freight: 0,
    #                        price: cells["G#{n}"], description: cells["N#{n}"], bill_time: cells["A#{n}"],
    #                        sale_customer_id: sale_customer.id, product_id: product.id, repo_id: repo.id, user_id: user.id)
    #
    #
    #     end
    #   end
    # end

    # if sheet.name == '收入详细'
    #   p '导入收入详细'
    #   sheet.rows_with_meta_data.each do |row|
    #     n = row['r']
    #     if n != "1" && n != "2"
    #       user = User.find(rand(1..3))
    #       cells = row['cells']
    #       #创建客户目录
    #       sale_customer = SaleCustomer.find_or_create_by(name: cells["B#{n}"])
    #       Proceed.find_or_create_by(sale_customer_id: sale_customer.id, user_id: user.id,
    #                                 paper_amount: cells["C#{n}"], actual_amount: cells["D#{n}"],
    #                                 remark: cells["E#{n}"], bill_time: cells["A#{n}"])
    #     end
    #   end
    # end

    # if sheet.name == '支出详细'
    #   p '导入支出详细'
    #   sheet.rows_with_meta_data.each do |row|
    #     n = row['r']
    #     if n != "1" && n != "2" && row['cells']["B#{n}"] != nil
    #       user = User.find(rand(1..3))
    #       cells = row['cells']
    #
    #       #查询供应商名单
    #       purchase_supplier = PurchaseSupplier.find_by(name: cells["B#{n}"])
    #       if purchase_supplier
    #         type = "货款"
    #       elsif cells["B#{n}"].include? "工资"
    #         type = "工资"
    #       elsif cells["B#{n}"].include? "改机"
    #         type = "改机"
    #       else
    #         type = "日常消耗"
    #       end
    #       expose = Expense.find_or_create_by(counterparty: cells["B#{n}"], expense_type: type, user_id: user.id,
    #                                          paper_amount: cells["C#{n}"], actual_amount: cells["D#{n}"],
    #                                          account_number: cells["F#{n}"], account_name: cells["E#{n}"],
    #                                          account_from: cells["G#{n}"], remark: cells["H#{n}"], bill_time: cells["A#{n}"])
    #       expose.build_purchase_supplier
    #     end
    #   end
    # end

  end
else
  p "没有初始资料.xlsm,导入预设的主要测试内容！"

  test_name = "测试用名字"
  test_supplier = "测试用供应商"
  test_address = "测试用地址"
  test_specification = "测试用型号规格"
  test_description = "测试用描述"
  test_batch_number = "测试用批号"
  test_contacts = "测试用联系人"
  test_phone = 12345678901

  repo = Repo.first
  user = User.first
  sale_customer = SaleCustomer.find_or_create_by(name: test_name, address: test_address, contacts: test_contacts, phone: test_phone)
  purchase_supplier = PurchaseSupplier.find_or_create_by(name: test_supplier, address: test_address, contacts: test_contacts, phone: test_phone)
  material = Material.find_or_create_by(name: test_name, specification: test_specification, purchase_supplier_id: purchase_supplier.id)
  product = Product.find_or_create_by(name: test_name, specification: test_specification, description: test_description)
  purchase_order = PurchaseOrder.find_or_create_by(batch_number: test_batch_number, description: test_description, measuring_unit: "件",
                                                   purchase_supplier: purchase_supplier, material: material, repo: repo, user: user,
                                                   number: rand(1..99), weight: rand(1..99), price: rand(1..99), deposit: rand(1..200),
                                                   bill_time: 1.day.ago)
  sale_order = SaleOrder.find_or_create_by(description: test_description, measuring_unit: "件", sale_customer: sale_customer,
                                           product: product, repo: repo, user: user, freight: rand(20..200),
                                           number: rand(1..99), weight: rand(1..99), price: rand(1..99), bill_time: 1.day.ago)

end