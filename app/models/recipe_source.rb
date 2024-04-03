class RecipeSource < ApplicationRecord

  belongs_to :recipe
  belongs_to :source

  accepts_nested_attributes_for :source

  def display_source
    if self.source.website?
      "#{self.source.source_type} - #{self.source.name} - "
    else
      "#{self.source.source_type} - #{self.source.name} - #{self.details}"
    end
  end
end
