require 'rails_helper'

RSpec.describe 'Homepage', type: :request do
  def menu_covering(*dates)
    Menu.create!(start_date: dates.min, end_date: dates.max)
  end

  def plan(date, *recipe_names)
    meal = Meal.create!(date: date, menu: menu_covering(date))
    recipe_names.each { |name| meal.recipes << Recipe.create!(name: name) }
    meal
  end

  describe 'when nothing is planned' do
    it 'shows the empty state with a link to the menus' do
      get root_path

      expect(response.body).to include('No upcoming meals')
      expect(response.body).to include(menus_path)
    end

    it 'does not render the menu sections' do
      get root_path

      expect(response.body).not_to include("On Today's Menu")
      expect(response.body).not_to include('Other Upcoming')
    end
  end

  describe 'when the only meals are in the past' do
    before { plan(Date.today - 1, 'Yesterday Stew') }

    it 'shows the empty state' do
      get root_path

      expect(response.body).to include('No upcoming meals')
      expect(response.body).not_to include('Yesterday Stew')
    end
  end

  describe 'when an upcoming meal has no recipes attached' do
    before { Meal.create!(date: Date.today + 2, menu: menu_covering(Date.today + 2)) }

    it 'shows the empty state' do
      get root_path

      expect(response.body).to include('No upcoming meals')
    end
  end

  describe "when a recipe is planned for today" do
    before { plan(Date.today, 'Apple Crumble') }

    it 'renders the menu sections instead of the empty state' do
      get root_path

      expect(response.body).not_to include('No upcoming meals')
      expect(response.body).to include("On Today's Menu")
    end

    it "lists the recipe in today's menu" do
      get root_path

      expect(response.body).to include('Apple Crumble')
    end
  end

  describe 'when a recipe is planned for later this week' do
    before { plan(Date.today + 3, 'Tiramisu') }

    it 'lists it under the upcoming recipes' do
      get root_path

      expect(response.body).not_to include('No upcoming meals')
      expect(response.body).to include('Other Upcoming')
      expect(response.body).to include('Tiramisu')
    end
  end

  describe 'when the same recipe is planned on several future days' do
    before do
      recipe = Recipe.create!(name: 'Ratatouille')
      [Date.today + 2, Date.today + 4].each do |date|
        meal = Meal.create!(date: date, menu: menu_covering(date))
        meal.recipes << recipe
      end
    end

    it 'lists it only once' do
      get root_path

      expect(response.body.scan('Ratatouille').size).to eq(1)
    end
  end
end
