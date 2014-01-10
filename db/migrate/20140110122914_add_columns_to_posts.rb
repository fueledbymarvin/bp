class AddColumnsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :video, :string
    add_column :posts, :image, :string
  end
end
