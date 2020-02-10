class BookPolicy < ApplicationPolicy
  def create?
    can_create?
  end

  def show?
    true
  end

  def update?
    can_update?
  end

  def destroy?
    can_destroy?
  end

  def checkin?
    can_checkin?
  end

  def checkout?
    can_checkout?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.is_admin?
        @scope.all
      else
        permitted_Book_ids = BookPermission.shared_Books(@user.id).pluck(:Book_id)
        if @user.role == 'USER'
          @scope.where(id: permitted_Book_ids)
        elsif @user.role == 'CLIENT'
          @scope.include_deleted.where(id: permitted_Book_ids)
        end
      end
    end
  end

  private
  def can_create?
    if @user && @user.role == 'LIBRARIAN'
      true
    else
      false
    end
  end

  def can_update?
    if @user && @user.role == 'LIBRARIAN'
      true
    else
      false
    end
  end

  def can_destroy?
    if @user && @user.role == 'LIBRARIAN'
      true
    else
      false
    end
  end

  def can_checkin?
    if @user
      true
    else
      false
    end
  end

  def can_checkout?
    if @user
      true
    else
      false
    end
  end

end
