class Source < ApplicationRecord

  has_many :recipe_sources
  has_many :recipes, :through => :recipe_sources

  validates_presence_of :name
  validates_presence_of :source_type

  enum source_type: {
    other: 0,
    website: 1,
    cookbook: 2,
    person: 3,
    course: 4
  }

end
