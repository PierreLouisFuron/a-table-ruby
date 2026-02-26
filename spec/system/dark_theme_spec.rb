require 'rails_helper'

RSpec.describe 'Dark theme', type: :system do
  def html_theme
    page.evaluate_script('document.documentElement.getAttribute("data-bs-theme")')
  end

  def icon_class
    page.evaluate_script('document.querySelector("[data-theme-target=\'icon\']").className')
  end

  def toggle_switch
    find('input[data-theme-target="switch"]', match: :first)
  end

  def emulate_color_scheme(scheme)
    page.driver.browser.execute_cdp('Emulation.setEmulatedMedia', features: [
      { name: 'prefers-color-scheme', value: scheme }
    ])
  end

  def ensure_light_mode
    # Headless Chrome defaults to dark, so we emulate light explicitly
    emulate_color_scheme('light')
  end

  def body_bg_color
    page.evaluate_script("getComputedStyle(document.body).backgroundColor")
  end

  def navbar_bg_color
    page.evaluate_script("getComputedStyle(document.querySelector('.navbar')).backgroundColor")
  end

  describe 'toggle switch' do
    it 'is present in the navbar' do
      visit root_path
      ensure_light_mode
      visit root_path

      expect(page).to have_css('input[data-theme-target="switch"]')
      expect(page).to have_css('i[data-theme-target="icon"]')
    end
  end

  describe 'default state' do
    it 'starts in light mode when OS prefers light' do
      visit root_path
      ensure_light_mode
      visit root_path

      expect(html_theme).to eq('light')
      expect(toggle_switch).not_to be_checked
    end
  end

  describe 'toggling theme' do
    before do
      visit root_path
      ensure_light_mode
      visit root_path
    end

    it 'switches to dark mode when clicked' do
      light_navbar_bg = navbar_bg_color

      toggle_switch.click

      expect(html_theme).to eq('dark')
      expect(toggle_switch).to be_checked
      expect(navbar_bg_color).not_to eq(light_navbar_bg)
      expect(body_bg_color).not_to eq('rgb(255, 255, 255)')
    end

    it 'switches back to light mode when clicked again' do
      light_navbar_bg = navbar_bg_color

      toggle_switch.click
      toggle_switch.click

      expect(html_theme).to eq('light')
      expect(toggle_switch).not_to be_checked
      expect(navbar_bg_color).to eq(light_navbar_bg)
    end
  end

  describe 'persistence' do
    before do
      visit root_path
      ensure_light_mode
      visit root_path
    end

    it 'persists dark mode across navigation' do
      toggle_switch.click
      expect(html_theme).to eq('dark')

      visit recipes_path
      expect(html_theme).to eq('dark')
      expect(toggle_switch).to be_checked
    end

    it 'persists dark mode across page reload' do
      toggle_switch.click
      expect(html_theme).to eq('dark')

      visit root_path
      expect(html_theme).to eq('dark')
      expect(toggle_switch).to be_checked
    end

    it 'stores the preference in localStorage' do
      toggle_switch.click

      stored = page.evaluate_script('localStorage.getItem("theme")')
      expect(stored).to eq('dark')
    end
  end

  describe 'system preference detection' do
    it 'follows OS dark mode preference when no manual choice is stored' do
      visit root_path
      emulate_color_scheme('dark')
      page.evaluate_script('localStorage.removeItem("theme")')
      visit root_path

      expect(html_theme).to eq('dark')
      expect(toggle_switch).to be_checked
    end

    it 'follows OS light mode preference when no manual choice is stored' do
      visit root_path
      emulate_color_scheme('light')
      page.evaluate_script('localStorage.removeItem("theme")')
      visit root_path

      expect(html_theme).to eq('light')
      expect(toggle_switch).not_to be_checked
    end
  end
end
