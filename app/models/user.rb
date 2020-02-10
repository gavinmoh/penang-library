class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist

  USER_ROLES = %w(LIBRARIAN PATREON)

  validates :role, inclusion: { in: USER_ROLES }
  validates :name, presence: true
end
