require 'rails_helper'

describe 'Recipe ingredient ordering', type: :system do
  let!(:recipe) { Recipe.create!(name: 'Probe Recipe') }

  before do
    %w[flour water salt].each do |name|
      recipe.recipe_ingredients.create!(ingredient: Ingredient.find_or_create_by(name: name))
    end
  end

  # The position controller imports Sortable from a CDN, so eager loading
  # registers it a little after the page is ready.
  def wait_for_position_controller
    Timeout.timeout(10) do
      sleep 0.1 until page.evaluate_script(
        "!!Stimulus.getControllerForElementAndIdentifier(document.getElementById('recipeIngredients'), 'position')"
      )
    end
  end

  # Sortable's own drag is covered by the library; what matters here is that the
  # resulting DOM order is what gets submitted, so move the row directly.
  def move_last_row_to_top
    page.execute_script(<<~JS)
      const container = document.getElementById('recipeIngredients');
      const rows = container.querySelectorAll('.nested-fields');
      container.insertBefore(rows[rows.length - 1], rows[0]);
    JS
  end

  it 'persists the order the rows appear in when the form is submitted' do
    visit edit_recipe_path(recipe)
    wait_for_position_controller
    move_last_row_to_top

    find('input[type="submit"]').click
    expect(page).to have_content('successfully updated')

    expect(recipe.reload.recipe_ingredients.map { |ri| ri.ingredient.name })
      .to eq(%w[salt flour water])
    expect(recipe.recipe_ingredients.map(&:position)).to eq([0, 1, 2])
  end

  it 'shows the stored order on the recipe page' do
    visit edit_recipe_path(recipe)
    wait_for_position_controller
    move_last_row_to_top
    find('input[type="submit"]').click
    expect(page).to have_content('successfully updated')

    listed = page.all('[data-servings-target="ingredient"]').map { |li| li['data-name'] }
    expect(listed).to eq(%w[Salt Flour Water])
  end
end
