class Source < ApplicationRecord

  has_many :recipe_sources
  has_many :recipes, :through => :recipe_sources

  before_validation :strip_whitespace

  validates_presence_of :name
  validates_presence_of :source_type

  enum source_type: {
    other: 0,
    website: 1,
    cookbook: 2,
    person: 3,
    course: 4
  }

  def fa_icon
    fa_mapping = {
      other: 'circle-question',
      website: 'earth-europe',
      cookbook: 'book',
      person: 'user',
      course: 'school'
    }
    fa_mapping[self.source_type.to_sym]
  end

  private

  def strip_whitespace
    self.name = name.strip
  end

end
