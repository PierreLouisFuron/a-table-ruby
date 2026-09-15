require 'rails_helper'

RSpec.describe 'Adding an ingredient to a recipe', type: :system do
  let!(:recipe) do
    recipe = Recipe.create!(name: 'Chocolate Cake')
    RecipeIngredient.create!(recipe: recipe, ingredient: Ingredient.create!(name: 'flour'))
    recipe
  end

  def ingredient_name_inputs
    all('.nested-fields .ingredients input[type="text"]', visible: true)
  end

  it 'moves the cursor to the newly added ingredient name field' do
    visit edit_recipe_path(recipe)

    expect(ingredient_name_inputs.size).to eq(1)

    click_link 'add ingredient'

    expect(page).to have_css('.nested-fields .ingredients input[type="text"]', count: 2)

    new_input = ingredient_name_inputs.last
    expect(page.evaluate_script('document.activeElement')).to eq(new_input)
    expect(new_input.value).to be_blank
  end
end
