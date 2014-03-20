class Post < ActiveRecord::Base
	belongs_to :user

	validates_presence_of :title, :author, :image, :content
end
