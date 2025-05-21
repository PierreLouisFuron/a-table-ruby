require 'spec_helper'
require 'rails_helper'

describe Recipe, type: :model do
  context 'validations' do
    it 'is valid with a name' do
      recipe = Recipe.new(name: 'Tiramisu')
      expect(recipe).to be_valid
    end
  end
end
