class PostNotNullSwap < ActiveRecord::Migration[7.2]
  def change
    change_column_null :posts, :topic_id, true
    change_column_null :topics, :post_id, false
    remove_index :posts, :user_id, unique: true
    add_index :posts, :user_id

    add_column :topics, :user_id, :bigint, null: false
    add_index :topics, :user_id
  end
end
