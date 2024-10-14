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
  has_rich_text :description

  validates_length_of :title, length: 4..255, allow_blank: false
  validates :description, no_attachments: true

  has_many :topics, -> { order(updated_at: :desc) }
  has_many :posts

  scope :visible_to, -> (user) { all }

  def to_s
    title
  end
end
