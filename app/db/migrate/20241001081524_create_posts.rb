class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.text :body
      t.references :forum
      t.references :topic
      t.references :user

      t.timestamps
    end
  end
end
