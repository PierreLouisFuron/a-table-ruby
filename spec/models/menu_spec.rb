require 'rails_helper'

RSpec.describe Menu, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  around { |example| travel_to(Time.zone.local(2026, 10, 9, 12)) { example.run } }

  describe '.expired' do
    it 'uses the end date, excluding menus ending today or later' do
      expired = Menu.create!(start_date: Date.today - 3, end_date: Date.today - 1)
      Menu.create!(start_date: Date.today - 3, end_date: Date.today)
      Menu.create!(start_date: Date.today - 3, end_date: Date.today + 1)

      expect(Menu.expired).to eq([expired])
    end

    it 'orders by most recent start date rather than end date or creation order' do
      recent = Menu.create!(start_date: Date.today - 3, end_date: Date.today - 2)
      older = Menu.create!(start_date: Date.today - 5, end_date: Date.today - 1)

      expect(Menu.expired).to eq([recent, older])
    end
  end
end
