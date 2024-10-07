class ForumDescriptionRichText < ActiveRecord::Migration[7.2]
  include ActionView::Helpers::TextHelper

  def change
    rename_column :forums, :description, :description_old
    Forum.all.each do |f|
      f.update_attribute(:description, simple_format(f.description_old))
    end
    remove_column :forums, :description_old
  end
end
