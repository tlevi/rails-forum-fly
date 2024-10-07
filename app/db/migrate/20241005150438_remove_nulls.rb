class RemoveNulls < ActiveRecord::Migration[7.2]
  def change
    change_column_null :forums, :title, false

    change_column_null :topics, :title, false
    change_column_null :topics, :forum_id, false

    change_column_null :posts, :body, false
    change_column_null :posts, :forum_id, false
    change_column_null :posts, :topic_id, false
    change_column_null :posts, :user_id, false

    change_column_null :users, :email, false
    change_column_null :users, :preferredname, false
    change_column_null :users, :role, false
    change_column_null :users, :username, false
  end
end
