require 'spec_helper'
require 'rails_helper'

describe Recipe, type: :model do
  let!(:recipe) { Recipe.create(name: 'Apple Crumble')}

  context 'validations' do
    it 'is valid with a name' do
      recipe = Recipe.new(name: 'Tiramisu')
      expect(recipe).to be_valid
    end

    it 'is invalid without a name' do
      recipe = Recipe.new
      expect(recipe).not_to be_valid
    end
  end

  context 'persistence' do
    it 'can be created' do
      expect {
        Recipe.create(name: 'Tiramisu')
      }.to change { Recipe.count }.by(1)
    end

    it 'can be destroyed' do
      expect {
        Recipe.first.destroy
      }.to change { Recipe.count }.by(-1)
    end

    it 'can be updated' do
      recipe = Recipe.new(name: 'Tiramisu')
      recipe.name = 'Salad'
      recipe.save
      expect(recipe.name).to eq('Salad')
    end
  end

  context 'associations' do
    it { should have_many(:ingredients) }
    it { should have_many(:sources) }
    it { should have_and_belong_to_many(:tags) }
    it { should have_and_belong_to_many(:meals) }

    it 'can have many images attached' do
      file1 = fixture_file_upload(Rails.root.join('spec/fixtures/files/sample1.jpg'), 'image/jpeg')
      file2 = fixture_file_upload(Rails.root.join('spec/fixtures/files/sample2.jpg'), 'image/jpeg')

      recipe.images.attach([file1, file2])

      expect(recipe.images.count).to eq(2)
      expect(recipe.images).to all(be_an_instance_of(ActiveStorage::Attachment))
    end

    it 'deletes attached images when destroyed' do
      recipe = Recipe.first
      recipe.images.attach(fixture_file_upload(Rails.root.join('spec/fixtures/files/sample1.jpg'), 'image/jpeg'))

      expect {
        recipe.destroy
      }.to change(ActiveStorage::Attachment, :count).by(-1)
    end
  end

  describe '.search' do
    context 'when searching by name' do
      it 'returns recipes with matching name' do
        recipe2 = Recipe.create(name: 'Tiramisu')
        results = Recipe.search('apple')
        expect(results).to include(recipe)
        expect(results).not_to include(recipe2)
      end
    end

    context 'when searching by ingredients' do
      it 'return recipes with matching ingredients' do
        recipe.ingredients.create!(name: 'eggs')
        recipe.ingredients.create!(name: 'apple')
        recipe.ingredients.create!(name: 'flour')
        recipe.ingredients.create!(name: 'sugar')

        recipe2 = Recipe.create!(name: 'Tiramisu')
        recipe2.ingredients.create!(name: 'flour')
        recipe2.ingredients.create!(name: 'coffee')

        results = Recipe.search('flour', {include_ingredients: true})
        expect(results).to include(recipe)
        expect(results.map(&:name)).to eq(['Apple Crumble', 'Tiramisu'])
      end
    end

    context 'when searching by tags' do
      it 'return recipes with matching tags' do
        recipe.tags.create!(name: 'dessert')
        recipe.tags.create!(name: 'easy')

        Recipe.create!(name: 'Salad')

        results = Recipe.search('easy', {include_tags: true})
        expect(results).to include(recipe)
        expect(results.map(&:name)).to eq(['Apple Crumble'])
      end
    end

    context 'when searching by sources' do
      it 'return recipes with matching sources' do
        recipe.sources.create!(name: 'Marmiton', source_type: 1)

        results = Recipe.search('marmiton', {include_sources: true})
        expect(results).to include(recipe)
        expect(results.map(&:name)).to eq(['Apple Crumble'])
      end
    end
  end
end
