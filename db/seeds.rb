# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'creek'

creek = Creek::Book.new "顾丰.xlsm"

# creek.sheets.each do |sheet|
#
#   if sheet.name == '员工信息'
#     sheet.rows_with_meta_data.each do |row|
#       n = row['r']
#       if n != "1"
#         cells = row['cells']
#         Employee.create(name: cells["B#{n}"], gender: cells["C#{n}"], work_type: cells["D#{n}"], work_id: cells["A#{n}"],
#                         basic_wage: cells["E#{n}"], minimun_wage: cells["F#{n}"], house_allowance: cells["H#{n}"],
#                         other_allowance: cells["I#{n}"], phone: cells["J#{n}"], bank_card: cells["K#{n}"],
#                         work_status: cells["M#{n}"], entry_date: cells["N#{n}"], daparture_date: cells["O#{n}"])
#
#       end
#     end
#
#     #新建账户
#     users = ['李文强', '王朝辉', '姚一夫', '顾晁诚']
#     n = 1
#     users.each do |name|
#       employee = Employee.find_by(name: name)
#       if employee && employee.user == nil
#         employee.create_user(name: name, password: "123456", email: "123456#{n}@qq.com")
#         user = employee.user
#         if user.name == "李文强"
#           role = Role.new(name: "admin")
#           user.roles << role
#           user.save
#         end
#         # 新建一个受管理的本地仓库
#         user.create_repo(name: "本地#{n}号", description: "初始设定的仓库,受#{user.name}管理")
#         n += 1
#       end
#     end
#   end
# end

creek.sheets.each do |sheet|
  if sheet.name == '交易单'
    sheet.rows_with_meta_data.each do |row|
      n = row['r']
      if n != "1"
        user = User.find(rand(1..3))
        repo = Repo.find(rand(1..3))
        cells = row['cells']
        #记录供应商名字
        PurchaseSupplier.create(name: cells["E#{n}"])
        #创建原材料目录
        # purchase_supplier.materials.build(name: cells["B#{n}"], specification: cells["C#{n}"],
        #                                   batch_number: cells["D#{n}"], measuring_unit: "包/箱")
        # purchase_supplier.save!

        #导入以前的交易单
        order = PurchaseOrder.new(name: cells["B#{n}"], specification: cells["C#{n}"],
                                  batch_number: cells["D#{n}"],weight: cells["F#{n}"], number: cells["G#{n}"], measuring_unit: "包/箱",
                                  tax_rate: cells["J#{n}"], deposit: cells["L#{n}"], freight: cells["M#{n}"],
                                  description: cells["N#{n}"], created_at: cells["A#{n}"], price: cells["I#{n}"])
        order.repo = repo
        order.user = user
        order.purchase_supplier = PurchaseSupplier.find_by(name: cells["E#{n}"])
        order.save!
      end
    end
  end

  #
  # if sheet.name == '出货'
  #   sheet.rows_with_meta_data.each do |row|
  #     n = row['r']
  #     if n != "1"
  #       user = User.find(rand(1..3))
  #       repo = Repo.find(rand(1..3))
  #       cells = row['cells']
  #       # 创建客户名称
  #       SaleCustomer.create(name: cells["C#{n}"])
  #       #创建产品目录
  #       Product.create(name: cells["B#{n}"], specification: cells["D#{n}"], measuring_unit: "匹")
  #       #导入以前的出货单
  #       order = SaleOrder.new(weight: cells["E#{n}"], number: cells["F#{n}"], measuring_unit: "匹",
  #                             price: cells["G#{n}"], description: cells["N#{n}"], created_at: cells["A#{n}"])
  #       order.repo = repo
  #       order.user = user
  #       order.product = Product.find_by(name: cells["B#{n}"])
  #       order.sale_customer = SaleCustomer.find_by(name: cells["C#{n}"])
  #
  #       order.save
  #
  #     end
  #   end
  # end


end

