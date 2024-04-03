class Ingredient < ApplicationRecord

    has_many :recipe_ingredients
    has_many :recipes, :through => :recipe_ingredients

    validates_presence_of :name

    before_save :downcase_name

    def downcase_name
        self.name = self.name.downcase
    end

end
