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
  belongs_to :topic
  belongs_to :forum
end