class AddEditorToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :editor_id, :bigint
  end
end
