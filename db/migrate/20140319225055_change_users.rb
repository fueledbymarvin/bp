class ChangeUsers < ActiveRecord::Migration
  def change
  	change_table :users do |t|
	  	t.remove :gid
	  	t.string :gid
	end
  end
end
