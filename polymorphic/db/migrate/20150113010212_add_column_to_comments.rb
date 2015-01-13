class AddColumnToComments < ActiveRecord::Migration
  def change
    add_column :comments, :rating, :integer
  end
end
