
class ForumdescNotnull < ActiveRecord::Migration[7.2]
  def change
    ActiveRecord::Base.connection.execute("UPDATE forums SET description = '' WHERE description IS NULL")
    change_column_null :forums, :description, false
  end
end
