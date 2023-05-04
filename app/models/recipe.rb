class Recipe < ApplicationRecord
    has_and_belongs_to_many :tags, join_table: :recipe_tags
    # has_many :recipe_tags
    # has_many :tags, :through => :recipe_tags

    has_many :recipe_ingredients
    has_many :ingredients, :through => :recipe_ingredients

    attribute :prep_time, :integer, default: 0
    attribute :cooking_time, :integer, default: 0

    def prep_time_days
        if prep_time != 0
            prep_time / (24 * 60)
        end
    end 

    def prep_time_hours
        if prep_time != 0
            (prep_time / 60) % 24
        end
    end

    def prep_time_minutes
        if prep_time != 0
            prep_time % 60
        end
    end

    def cooking_time_days
        if cooking_time != 0
            cooking_time / (24 * 60)
        end
    end 

    def cooking_time_hours
        if cooking_time != 0
            (cooking_time / 60) % 24
        end
    end

    def cooking_time_minutes
        if cooking_time != 0
            cooking_time % 60
        end
    end
end