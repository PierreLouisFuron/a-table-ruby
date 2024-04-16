class Tag < ApplicationRecord
    has_and_belongs_to_many :recipes, join_table: :recipe_tags
    # has_many :recipe_tags
    # has_many :recipes, :through => :recipe_tags

    before_save :downcase_name

    def downcase_name
        self.name = self.name.downcase
    end
end
