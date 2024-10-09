# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  forum_id   :bigint
#  topic_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_posts_on_forum_id  (forum_id)
#  index_posts_on_topic_id  (topic_id)
#  index_posts_on_user_id   (user_id)
#
class Post < ApplicationRecord
  has_rich_text :body

  validates :body, no_attachments: true
  validates :body, :user_id, presence: true
  validates :user_id, uniqueness: true

  # TODO: add some way of showing posted was changed
  #validates :moderated, presence: true

  belongs_to :author, class_name: "User", foreign_key: "user_id"
  belongs_to :topic, inverse_of: :first_post, optional: true
  belongs_to :forum

  before_commit do
    if topic.blank?
      errors.add :topic, 'a topic must be associated with the post'
      throw :abort
    end
  end
end
