require 'rails_helper'

RSpec.describe 'Expired menu accordion', type: :system do
  it 'reveals the recipes when expanded and opens the selected recipe' do
    recipe = Recipe.create!(name: 'Archived Apple Crumble')
    menu = Menu.create!(start_date: Date.today - 2, end_date: Date.today - 1)
    menu.meals.create!(date: menu.start_date).recipes << recipe

    visit menus_path

    expect(page).to have_css('h1', text: 'Latest Expired Menus')
    within('#expiredMenusAccordion') do
      expect(page).not_to have_link(recipe.name)
      find("button[data-bs-target='#collapse_#{menu.id}']").click
      expect(page).to have_link(recipe.name, href: recipe_path(recipe))
      expect(page).to have_css("button[aria-controls='collapse_#{menu.id}'][aria-expanded='true']")
      click_link recipe.name
    end

    expect(page).to have_current_path(recipe_path(recipe))
    expect(page).to have_content(recipe.name)
  end
end
