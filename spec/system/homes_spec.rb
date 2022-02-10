# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Home', type: :system do
  it 'visiting the start page' do
    visit_home_page
    expect_to_see_home_page
  end

  private

  def expect_to_see_home_page
    expect(page).to have_content('Find a lost teacher reference number (TRN)')
  end

  def visit_home_page
    visit root_path
  end
end
