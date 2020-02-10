class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def history?
    if @user && @user.role == 'LIBRARIAN'
      true
    else
      false
    end
  end
end
