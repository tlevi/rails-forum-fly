class ForumDescription < ActiveRecord::Migration[7.2]
  def change
    add_column :forums	, :description, :text
  end
end
