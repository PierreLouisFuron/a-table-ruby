require 'rails_helper'

RSpec.describe 'Expired menus', type: :request do
  include ActiveSupport::Testing::TimeHelpers

  around { |example| travel_to(Time.zone.local(2026, 10, 9, 12)) { example.run } }

  def create_menu(start_date:, end_date:, recipes: [])
    menu = Menu.create!(start_date: start_date, end_date: end_date)
    meal = menu.meals.create!(date: start_date)
    recipes.each { |recipe| meal.recipes << recipe }
    menu
  end

  def document
    Nokogiri::HTML(response.body)
  end

  def expired_block
    document.at_css('#expiredMenusAccordion')
  end

  it 'renders the whole expired-menu section even when there are no menus' do
    get menus_path

    expect(response).to have_http_status(:ok)
    expect(document.css('h1').map(&:text)).to include('Latest Expired Menus')
    expect(expired_block).to be_present
    expect(expired_block.css('.accordion-item')).to be_empty
  end

  it 'only puts menus ending before today in the expired section' do
    recipe = Recipe.create!(name: 'Boundary Stew')
    expired = create_menu(start_date: Date.today - 2, end_date: Date.today - 1, recipes: [recipe])
    today = create_menu(start_date: Date.today - 1, end_date: Date.today, recipes: [recipe])
    future = create_menu(start_date: Date.today + 1, end_date: Date.today + 2, recipes: [recipe])

    get menus_path

    expect(expired_block.css('.accordion-collapse').map { |node| node['id'] }).to eq(["collapse_#{expired.id}"])
    expect(document.at_css("#menu_#{expired.id}")).to be_nil
    expect(document.at_css("#menu_#{today.id}")).to be_present
    expect(document.at_css("#menu_#{future.id}")).to be_present
  end

  it 'renders the date range and wires the collapsed button to its recipe panel' do
    menu = create_menu(start_date: Date.today - 3, end_date: Date.today - 1,
                       recipes: [Recipe.create!(name: 'Soup')])

    get menus_path

    button = expired_block.at_css('.accordion-header button')
    expect(button.text.squish).to eq('From Tuesday, October 06 to Thursday, October 08')
    expect(button['data-bs-target']).to eq("#collapse_#{menu.id}")
    expect(button['aria-controls']).to eq("collapse_#{menu.id}")
    expect(button['aria-expanded']).to eq('false')
    expect(expired_block.at_css("#collapse_#{menu.id}")['class'].split).to include('collapse')
  end

  it 'shows every recipe with its own detail link and lazy thumbnail' do
    recipes = ['Apple Crumble', 'Tomato Soup'].map { |name| Recipe.create!(name: name) }
    create_menu(start_date: Date.today - 1, end_date: Date.today - 1, recipes: recipes)

    get menus_path

    links = expired_block.css('.accordion-body a.list-group-item')
    expect(links.map { |link| link.text.squish }).to match_array(recipes.map(&:name))
    recipes.each do |recipe|
      link = links.find { |node| node['href'] == recipe_path(recipe) }
      expect(link).to be_present
      expect(link.text.squish).to eq(recipe.name)
      expect(link.at_css('img')['src']).to be_present
      expect(link.at_css('img')['loading']).to eq('lazy')
    end
  end

  it 'lists a recipe only once when it belongs to multiple meals in the menu' do
    recipe = Recipe.create!(name: 'Repeated Soup')
    menu = create_menu(start_date: Date.today - 2, end_date: Date.today - 1, recipes: [recipe])
    menu.meals.create!(date: Date.today - 1).recipes << recipe

    get menus_path

    expect(expired_block.css("a[href='#{recipe_path(recipe)}']").size).to eq(1)
  end

  it 'omits expired menus without recipes' do
    menu = create_menu(start_date: Date.today - 1, end_date: Date.today - 1)

    get menus_path

    expect(expired_block.at_css("#collapse_#{menu.id}")).to be_nil
    expect(expired_block.css('.accordion-item')).to be_empty
  end

  it 'shows only the five latest expired menus in descending start-date order' do
    recipe = Recipe.create!(name: 'Soup')
    menus = (1..6).map do |days_ago|
      create_menu(start_date: Date.today - days_ago, end_date: Date.today - days_ago, recipes: [recipe])
    end

    get menus_path

    expect(expired_block.css('.accordion-collapse').map { |node| node['id'] })
      .to eq(menus.first(5).map { |menu| "collapse_#{menu.id}" })
  end
end
