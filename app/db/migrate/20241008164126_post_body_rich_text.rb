class PostBodyRichText < ActiveRecord::Migration[7.2]
  include ActionView::Helpers::TextHelper

  def change
    rename_column :posts, :body, :body_old
    Post.all.each do |p|
      p.update_attribute(:body, simple_format(p.body_old))
    end
    remove_column :posts, :body_old
  end
end
