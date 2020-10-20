# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'creek'

creek = Creek::Book.new "顾丰.xlsm"

creek.sheets.each do |sheet|
  if sheet.name == '员工信息'
    sheet.rows_with_meta_data.each do |row|
      n = row['r']
      if n != "1"
        cells = row['cells']
        user = User.new(name: cells["B#{n}"], gender: cells["C#{n}"], work_type: cells["D#{n}"], work_id: cells["A#{n}"],
                        basic_wage: cells["E#{n}"], minimun_wage: cells["F#{n}"], house_allowance: cells["H#{n}"],
                        other_allowance: cells["I#{n}"], phone: cells["J#{n}"], bank_card: cells["K#{n}"],
                        work_status: cells["M#{n}"], entry_date: cells["N#{n}"], daparture_date: cells["O#{n}"])
        user.password = "123456"
        user.save
      end
    end
  end


end

