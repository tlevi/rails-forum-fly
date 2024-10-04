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
  validates :username, uniqueness: true
  validates :email, uniqueness: true

  has_secure_password
end
