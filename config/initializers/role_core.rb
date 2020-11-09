# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# For I18n, see `config/locales/role_core.en.yml` for details which followed the rule of ActiveRecord's I18n,
# See <http://guides.rubyonrails.org/i18n.html#translations-for-active-record-models>.

require "role_core/contrib/can_can_can_permission"
RoleCore.permission_class = RoleCore::CanCanCanPermission

RoleCore.permission_set_class.draw do
  group :users, model_name: "User" do
    permission :create
    permission :destroy
    permission :update
    permission :read, _priority: 1
    permission :read_my_own, action: :read, default: true do |user, task|
      task.id == user.id
    end
    permission :reset
    permission :lock, _priority: 1
  end
  group :roles, model_name: "Role" do
    permission :create
    permission :destroy
    permission :update
    permission :read, _priority: 1, default: true
  end
  group :employee, model_name: "Employee" do
    permission :create
    permission :destroy
    permission :update
    permission :read, _priority: 1, default: true
  end
  group :repos, model_name: "Repo" do
    permission :create
    permission :destroy
    permission :update
    permission :read, _priority: 1, default: true
  end
  group :products, model_name: "Product" do
    permission :create
    permission :destroy
    permission :update
    permission :read, _priority: 1, default: true
  end
  group :materials, model_name: "Material" do
    permission :create
    permission :destroy
    permission :update
    permission :read, _priority: 1, default: true
  end
  group :sale_customers, model_name: "SaleCustomer" do
    permission :create
    permission :destroy, _priority: 1
    permission :update, _priority: 1
    permission :read, _priority: 1, default: true
    permission :export
  end
  group :sale_orders, model_name: "SaleOrder" do
    permission :create
    permission :destroy, _priority: 1
    permission :update, _priority: 1
    permission :pass_check
    permission :read, _priority: 1, default: true
    permission :update_my_own, action: :update, default: true do |user, task|
      task.user_id == user.id
    end
    permission :destroy_my_own, action: :destroy, default: true do |user, task|
      task.user_id == user.id
    end
  end
  group :purchase_orders, model_name: "PurchaseOrder" do
    permission :create
    permission :destroy, _priority: 1
    permission :update, _priority: 1
    permission :pass_check
    permission :read, _priority: 1, default: true
    permission :update_my_own, action: :update, default: true do |user, task|
      task.user_id == user.id
    end
    permission :destroy_my_own, action: :destroy, default: true do |user, task|
      task.user_id == user.id
    end
  end
  group :purchase_suppliers, model_name: "PurchaseSupplier" do
    permission :create
    permission :destroy, _priority: 1
    permission :update, _priority: 1
    permission :read, _priority: 1, default: true
    permission :export
  end
  group :params, model_name: "Param" do
    permission :update, _priority: 1
    permission :read, _priority: 1, default: true
  end
  group :expenses, model_name: "Expense" do
    permission :create
    permission :destroy, _priority: 1
    permission :update, _priority: 1
    permission :pass_check
    permission :pass_reimburse
    permission :read, _priority: 1, default: true
    permission :update_my_own, action: :update, default: true do |user, task|
      task.user_id == user.id
    end
    permission :destroy_my_own, action: :destroy, default: true do |user, task|
      task.user_id == user.id
    end
  end
  group :proceeds, model_name: "Proceed" do
    permission :create
    permission :destroy, _priority: 1
    permission :update, _priority: 1
    permission :pass_check
    permission :read, _priority: 1, default: true
    permission :update_my_own, action: :update, default: true do |user, task|
      task.user_id == user.id
    end
    permission :destroy_my_own, action: :destroy, default: true do |user, task|
      task.user_id == user.id
    end
  end
  group :comments, model_name: "Comment" do
    permission :create
    permission :destroy, _priority: 1
    permission :update, _priority: 1
    permission :take_top, _priority: 1
    permission :read, _priority: 1, default: true
    permission :update_my_own, action: :update, default: true do |user, task|
      task.user_id == user.id
    end
    permission :destroy_my_own, action: :destroy, default: true do |user, task|
      task.user_id == user.id
    end
  end

  permission :super, action: :manage, subject: :all
# These (under the comment) are not in use, just for demo

# permission :foo, _callable: false
# permission :bar, _callable: false
#
# group :task, _callable: false do
#   permission :read
#   permission :create, default: true
#   permission :destroy
#   permission :update
# end
end.finalize!
