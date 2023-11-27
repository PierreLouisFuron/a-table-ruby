class Recipe < ApplicationRecord
    has_and_belongs_to_many :tags, join_table: :recipe_tags
    
    # has_many :photos, dependent: :destroy
    has_many_attached :images

    has_many :recipe_ingredients
    has_many :ingredients, :through => :recipe_ingredients
    accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true

    validates_presence_of :name
    validates_uniqueness_of :name
    
    attribute :prep_time, :integer, default: 0
    attribute :cooking_time, :integer, default: 0

    before_save :find_or_create_ingredients

    def get_square_thumbnail
        if self.images.empty?
            'placeholders/placeholder.png'
            # image = MiniMagick::Image.open(image_path)
        else
            self.images.first.variant(resize_to_fill: [300, 300], gravity: 'Center').processed
        end
    end

    def get_cover_thumbnail
        if self.images.empty?
            'placeholders/placeholder.png'
        else
            self.images.first.variant(resize_to_limit: [300, 300]).processed
        end
    end

    def get_cover_image
        if self.images.empty?
            'placeholders/placeholder.png'
        else
            self.images.first
        end
    end

    def find_or_create_ingredients
        self.recipe_ingredients.each do |recipe_ingredient|
            recipe_ingredient.ingredient = Ingredient.find_or_create_by(name:recipe_ingredient.ingredient.name)
        end
    end

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