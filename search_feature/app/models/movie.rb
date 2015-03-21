class Movie < ActiveRecord::Base
  has_many :cast_members
  has_many :actors, through: :cast_members

  def self.search(query)
    where("plainto_tsquery(?) @@ " +
      "to_tsvector('english', title || ' ' || synopsis)",
      query)
  end
end
