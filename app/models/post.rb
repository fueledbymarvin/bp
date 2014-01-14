class Post < ActiveRecord::Base
  validates_presence_of :title, :author, :image, :content
end
