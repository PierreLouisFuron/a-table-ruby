class Menu < ApplicationRecord

  has_many :meals, dependent: :destroy

  validates_presence_of :start_date
  validates_presence_of :end_date

  scope :ongoing, -> { where("end_date >= ?", Date.today) }

  def all_ingredients
    meals.includes(recipes: :ingredients).flat_map(&:all_ingredients).uniq
  end

  def all_ingredients_by_date
    meals.includes(recipes: :ingredients)
         .group_by(&:date)
         .transform_values { |day_meals| day_meals.flat_map(&:all_ingredients).uniq }
  end

  def all_ingredients_for_date(date)
    all_ingredients_by_date[date] || []
  end

end
