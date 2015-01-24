class Post < ActiveRecord::Base
  is_sluggable :title
  has_many :comments, as: :commentable
end
