# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    case user.role.to_sym
    when :admin
      can :manage, :all
    when :employee
      can :manage, Issue
    when :resident
      can :read, Issue, created_by: user.id
      can :create, Issue
      can :update, Issue, created_by: user.id
    end
  end
end
