class Actor < ActiveRecord::Base
  has_many :cast_members
  has_many :movies, through: :cast_members
end
