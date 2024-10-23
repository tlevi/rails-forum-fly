class TopicCounters < ActiveRecord::Migration[7.2]
  def change
    add_column :topics, :view_count, :bigint, null: false, default: 0
    add_column :topics, :reply_count, :bigint, null: false, default: 0
  end
end
