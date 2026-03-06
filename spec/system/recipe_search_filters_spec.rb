require 'rails_helper'

RSpec.describe 'Recipe search filters', type: :system do
  let!(:recipe_by_name) { Recipe.create!(name: 'Chocolate Cake') }
  let!(:recipe_by_ingredient) do
    recipe = Recipe.create!(name: 'Plain Salad')
    ingredient = Ingredient.create!(name: 'tomato')
    RecipeIngredient.create!(recipe: recipe, ingredient: ingredient)
    recipe
  end
  let!(:recipe_by_tag) do
    recipe = Recipe.create!(name: 'Simple Soup')
    tag = Tag.create!(name: 'vegan')
    recipe.tags << tag
    recipe
  end
  let!(:recipe_by_source) do
    recipe = Recipe.create!(name: 'Basic Pasta')
    source = Source.create!(name: 'grandma', source_type: :person)
    RecipeSource.create!(recipe: recipe, source: source)
    recipe
  end

  def filter_button(label)
    within('.btn-group') do
      find('label', text: label, match: :prefer_exact)
    end
  end

  def filter_checkbox(name)
    find("#filter_#{name}", visible: :all)
  end

  def search_for(query)
    within('.btn-group ~ .input-group') do
      find('input[name="search"]').fill_in(with: query)
    end
    within('.btn-group ~ .input-group') do
      find('button.btn-primary').click
    end
  end

  describe 'default state' do
    it 'has Recipes enabled and the others disabled by default' do
      visit recipes_path

      expect(filter_checkbox('recipes')).to be_checked
      expect(filter_checkbox('ingredients')).not_to be_checked
      expect(filter_checkbox('tags')).not_to be_checked
      expect(filter_checkbox('sources')).not_to be_checked
    end
  end

  describe 'toggling filters' do
    before { visit recipes_path }

    it 'can enable and disable the Recipes button' do
      filter_button('Recipes').click
      expect(filter_checkbox('recipes')).not_to be_checked

      filter_button('Recipes').click
      expect(filter_checkbox('recipes')).to be_checked
    end

    it 'can enable and disable the Ingredients button' do
      filter_button('Ingredients').click
      expect(filter_checkbox('ingredients')).to be_checked

      filter_button('Ingredients').click
      expect(filter_checkbox('ingredients')).not_to be_checked
    end

    it 'can enable and disable the Tags button' do
      filter_button('Tags').click
      expect(filter_checkbox('tags')).to be_checked

      filter_button('Tags').click
      expect(filter_checkbox('tags')).not_to be_checked
    end

    it 'can enable and disable the Sources button' do
      filter_button('Sources').click
      expect(filter_checkbox('sources')).to be_checked

      filter_button('Sources').click
      expect(filter_checkbox('sources')).not_to be_checked
    end
  end

  describe 'searching with filters' do
    before { visit recipes_path }

    it 'searches by recipe name when Recipes is selected' do
      search_for('chocolate')

      expect(page).to have_text('Chocolate Cake')
      expect(page).not_to have_text('Plain Salad')
    end

    it 'searches by ingredient name when Ingredients is selected' do
      filter_button('Recipes').click
      filter_button('Ingredients').click
      search_for('tomato')

      expect(page).to have_text('Plain Salad')
      expect(page).not_to have_text('Chocolate Cake')
    end

    it 'searches by tag name when Tags is selected' do
      filter_button('Recipes').click
      filter_button('Tags').click
      search_for('vegan')

      expect(page).to have_text('Simple Soup')
      expect(page).not_to have_text('Chocolate Cake')
    end

    it 'searches by source name when Sources is selected' do
      filter_button('Recipes').click
      filter_button('Sources').click
      search_for('grandma')

      expect(page).to have_text('Basic Pasta')
      expect(page).not_to have_text('Chocolate Cake')
    end

    it 'searches across all filters when all are selected' do
      filter_button('Ingredients').click
      filter_button('Tags').click
      filter_button('Sources').click

      search_for('chocolate')
      expect(page).to have_text('Chocolate Cake')

      search_for('tomato')
      expect(page).to have_text('Plain Salad')

      search_for('vegan')
      expect(page).to have_text('Simple Soup')

      search_for('grandma')
      expect(page).to have_text('Basic Pasta')
    end
  end

  describe 'default fallback' do
    before { visit recipes_path }

    it 'defaults to searching by recipe name when no filter is selected' do
      filter_button('Recipes').click
      search_for('chocolate')

      expect(page).to have_text('Chocolate Cake')
      expect(filter_checkbox('recipes')).to be_checked
    end
  end
end
