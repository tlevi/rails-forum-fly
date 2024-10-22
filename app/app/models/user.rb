# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string
#  password_digest :string
#  preferredname   :string
#  role            :string
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true
  validates :preferredname, presence: true
  validates :role, presence: true

  DB_ROLES = %w[guest member moderator admin]
  enum :role, DB_ROLES.index_by(&:to_sym)

  has_secure_password

  def is_member?
    role == 'member' || is_moderator?
  end

  def is_moderator?
    role == 'moderator' || is_admin?
  end

  def is_admin?
    role == 'admin'
  end

  def is_guest?
    !is_member?
  end
end
