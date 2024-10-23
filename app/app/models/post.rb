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
  validates :topic, :presence => true, :on => :update

  # TODO: add some way of showing posted was changed
  #validates :moderated, presence: true

  belongs_to :author, class_name: "User", foreign_key: "user_id"
  belongs_to :editor, class_name: "User", foreign_key: "editor_id", optional: true
  belongs_to :topic, inverse_of: :posts, optional: true, autosave: true, touch: true, counter_cache: :reply_count
  belongs_to :forum

  def is_first?
    topic.first_post.id == self.id
  end
end
