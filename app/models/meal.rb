class Meal < ApplicationRecord

  has_and_belongs_to_many :recipes
  belongs_to :menu

  scope :on, ->(date) { where(date: date)}
  scope :after, ->(date) { where('meals.date > ?', date)}
  scope :upcoming, -> { where('meals.date >= ?', Date.today).joins(:recipes) }

  def all_ingredients
    recipes.flat_map(&:ingredients).uniq
  end
end
