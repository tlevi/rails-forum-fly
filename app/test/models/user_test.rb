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
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
