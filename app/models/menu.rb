class Menu < ApplicationRecord

  has_many :meals, dependent: :destroy

  validates_presence_of :start_date
  validates_presence_of :end_date

  scope :ongoing, -> { where("end_date >= ?", Date.today) }
end
