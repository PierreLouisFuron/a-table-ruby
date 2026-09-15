require 'rails_helper'

RSpec.describe 'Selecting a tag on a recipe', type: :system do
  let!(:dessert_tag) { Tag.create!(name: 'dessert') }
  let!(:dinner_tag) { Tag.create!(name: 'dinner') }
  let!(:recipe) { Recipe.create!(name: 'Chocolate Cake') }

  # The Tom-Select text input the user types into
  def tag_input
    find('.ts-wrapper .ts-control input')
  end

  def selected_tag_names
    all('.ts-wrapper .ts-control .item').map(&:text)
  end

  it 'clears the typed text once a tag is picked from the dropdown' do
    visit edit_recipe_path(recipe)

    tag_input.send_keys('des')
    expect(page).to have_css('.ts-dropdown .option', text: 'dessert')

    find('.ts-dropdown .option', text: 'dessert').click

    expect(selected_tag_names).to eq(['dessert'])
    expect(tag_input.value).to be_blank
  end

  it 'keeps previously selected tags when adding another' do
    visit edit_recipe_path(recipe)

    tag_input.send_keys('dessert')
    find('.ts-dropdown .option', text: 'dessert').click

    tag_input.send_keys('din')
    expect(page).to have_css('.ts-dropdown .option', text: 'dinner')
    find('.ts-dropdown .option', text: 'dinner').click

    expect(selected_tag_names).to match_array(%w[dessert dinner])
    expect(tag_input.value).to be_blank
  end

  it 'saves only the selected tags, not the partially typed text' do
    visit edit_recipe_path(recipe)

    tag_input.send_keys('des')
    find('.ts-dropdown .option', text: 'dessert').click

    click_button 'Update Recipe'

    expect(page).to have_current_path(recipe_path(recipe))
    expect(recipe.reload.tags.map(&:name)).to eq(['dessert'])
  end

  it 'does not create a tag when clicking away mid-typing' do
    visit edit_recipe_path(recipe)

    tag_input.send_keys('des')
    find('#recipe_description').click # blur the tag field

    expect(selected_tag_names).to be_empty

    click_button 'Update Recipe'

    expect(page).to have_current_path(recipe_path(recipe))
    expect(recipe.reload.tags).to be_empty
    expect(Tag.where(name: 'des')).to be_empty
  end
end
