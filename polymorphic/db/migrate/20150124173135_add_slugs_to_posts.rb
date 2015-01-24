class AddSlugsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :cached_slug, :string
    add_index :posts, :cached_slug
  end
end
