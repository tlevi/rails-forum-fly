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
  validates :email, uniqueness: true, presence: true
  validates :preferredname, presence: true
  validates :role, presence: true

  DB_ROLES = %w[member moderator admin]
  enum role: DB_ROLES.index_by(&:to_sym)

  has_secure_password
end
