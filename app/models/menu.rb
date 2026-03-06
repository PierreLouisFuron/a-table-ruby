class Menu < ApplicationRecord

  has_many :meals, dependent: :destroy

  validates_presence_of :start_date
  validates_presence_of :end_date

  scope :ongoing, -> { where("end_date >= ?", Date.today) }

  def get_menu_ingredients
    ingredients = []

    self.meals.each do |meal|
      meal.recipes.each do |recipe|
        recipe.ingredients.each do |ingredient|
          ingredients << ingredient
        end
      end
    end
    ingredients
  end

end
