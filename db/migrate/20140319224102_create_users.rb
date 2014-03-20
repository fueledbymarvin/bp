class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :image
      t.integer :gid
      t.text :blurb
      t.string :year

      t.timestamps
    end
  end
end
