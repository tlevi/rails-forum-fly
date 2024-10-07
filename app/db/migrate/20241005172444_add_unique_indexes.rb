class AddUniqueIndexes < ActiveRecord::Migration[7.2]
  def change
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true

    remove_index :posts, :user_id
    add_index :posts, :user_id, unique: true

    change_column_null :posts, :topic_id, false
  end
end
