# == Schema Information
#
# Table name: forums
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Forum < ApplicationRecord
  has_many :topics
  has_many :posts

  scope :visible_to, -> (user) { all }
end
