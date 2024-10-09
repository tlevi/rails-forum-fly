# == Schema Information
#
# Table name: topics
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  forum_id   :bigint
#  post_id    :bigint
#
# Indexes
#
#  index_topics_on_forum_id  (forum_id)
#  index_topics_on_post_id   (post_id)
#
class Topic < ApplicationRecord
  validates :title, :forum, :author, presence: true

  belongs_to :forum
  belongs_to :author, class_name: "User", foreign_key: "user_id"
  belongs_to :first_post, class_name: "Post", foreign_key: "post_id", inverse_of: 'topic'

  has_many :posts, :dependent => :destroy
end
