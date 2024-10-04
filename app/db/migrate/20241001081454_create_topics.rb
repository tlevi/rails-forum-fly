class CreateTopics < ActiveRecord::Migration[7.2]
  def change
    create_table :topics do |t|
      t.string :title
      t.references :forum
      t.references :post

      t.timestamps
    end
  end
end
