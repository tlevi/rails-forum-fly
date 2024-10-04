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
  belongs_to :forum
end
