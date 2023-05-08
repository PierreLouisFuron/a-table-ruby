class Recipe < ApplicationRecord
    has_and_belongs_to_many :tags, join_table: :recipe_tags
    # has_many :recipe_tags
    # has_many :tags, :through => :recipe_tags

    has_many :recipe_ingredients
    has_many :ingredients, :through => :recipe_ingredients

    attribute :prep_time, :integer, default: 0
    attribute :cooking_time, :integer, default: 0

    def prep_time_days
        prep_time / (24 * 60) != 0 ? prep_time / (24 * 60) : nil
    end 

    def prep_time_hours
        (prep_time / 60) % 24 != 0 ? (prep_time / 60) % 24 : nil
    end

    def prep_time_minutes
        prep_time % 60 != 0 ? prep_time % 60 : nil
    end

    def cooking_time_days
        cooking_time / (24 * 60) != 0 ? cooking_time / (24 * 60) : nil
    end 

    def cooking_time_hours
        (cooking_time / 60) % 24 != 0 ? (cooking_time / 60) % 24 : nil
    end

    def cooking_time_minutes
        cooking_time % 60 != 0 ? cooking_time % 60 : nil
    end
end