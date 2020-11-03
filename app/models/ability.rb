# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    if user.has_role?(:admin)
      can :manage, :all
    else
      can :manage, :all
      # # Employee
      # can :read, Employee do |p|
      #   user.has_role?(:read, Employee)
      # end
      # can :create, Employee do |p|
      #   user.has_role?(:create, Employee)
      # end
      # can :update, Employee do |p|
      #   user.has_role?(:update, Employee)
      # end
      # # User
      # if user.has_role?(:index, User)
      #   can :index, User
      # end
      # if user.has_role?(:show, User.find(user.id))
      #   can :show, User, id: user.id
      # end
      #
      # can :create, User do |p|
      #   user.has_role?(:director)
      # end
      # can :update, User do |p|
      #   user.has_role?(:director) || (p.id == user.id)
      # end
      # can :lock, User do |p|
      #   user.has_role?(:director)
      # end
      #
      # # PasswordResetsController
      # can? :reset, User do |p|
      #   user.has_role?(:director) || (p.id == user.id)
      # end
      # # PurchaseOrder
      # can :index, PurchaseOrder do |p|
      #   user.has_role?(:director, :accounting, :buyer)
      # end
      # can :show, PurchaseOrder do |p|
      #   user.has_role?(:director, :accounting) || (user.has_role?(:buyer) && (p.user_id == user.id))
      # end
      #
      # can :create, PurchaseOrder do |p|
      #   user.has_role?(:buyer)
      # end
      # can :update, PurchaseOrder do |p|
      #   user.has_role?(:director) || (user.has_role?(:buyer) && (p.user_id == user.id))
      # end
      # can :destroy, PurchaseOrder do |p|
      #   user.has_role?(:director) || (user.has_role?(:buyer) && (p.user_id == user.id))
      # end
      # can :pass_check, PurchaseOrder do |p|
      #   user.has_role?(:director)
      # end
      #
      #
      # # PurchaseSupplier
      # can :read, PurchaseSupplier do |p|
      #   user.has_role?(:director, :accounting, :buyer)
      # end
      # can :update, PurchaseSupplier do |p|
      #   user.has_role?(:director, :accounting, :buyer)
      # end
      #
      # # SaleOrder
      # can :read, SaleOrder do |p|
      #   user.has_role?(:director, :accounting) || (user.has_role?(:saler) && (p.user_id == user.id))
      # end
      # can :create, SaleOrder do |p|
      #   user.has_role?(:saler)
      # end
      # can :update, SaleOrder do |p|
      #   user.has_role?(:director) || (user.has_role?(:saler) && (p.user_id == user.id))
      # end
      # can :destroy, SaleOrder do |p|
      #   user.has_role?(:director) || (user.has_role?(:saler) && (p.user_id == user.id))
      # end
      # can :pass_check, SaleOrder do |p|
      #   user.has_role?(:director)
      # end
      #
      # # SaleCustomer
      # can :read, SaleCustomer do |p|
      #   user.has_role?(:director, :accounting, :saler)
      # end
      # can :update, SaleCustomer do |p|
      #   user.has_role?(:director, :accounting, :saler)
      # end


    end


    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
