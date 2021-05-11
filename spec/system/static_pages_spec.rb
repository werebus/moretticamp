# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'static pages' do
  let :user do
    create :user
  end

  before do
    sign_in user
  end

  %w[documents].each do |page_name|
    it "has a #{page_name} page" do
      visit method(:"#{page_name}_page_path").call
      expect(page).to have_text(page_name.capitalize)
    end
  end
end
