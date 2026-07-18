# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SeasonsController#index' do
  subject(:index) { page }

  before do
    sign_in create(:user, admin: true)
  end

  context 'with an unavailable season' do
    let!(:season) { create :season, available: 1.week.from_now }

    before { visit seasons_path }

    it { is_expected.to have_css("tr[data-season-id='#{season.id}'].table-warning") }
  end

  context 'with a future season' do
    let!(:season) { create :season, start_date: 1.week.from_now, end_date: 1.year.from_now, available: 1.week.ago }

    before { visit seasons_path }

    it { is_expected.to have_css("tr[data-season-id='#{season.id}'].table-info") }
  end

  context 'with a current season' do
    let!(:season) { create :season, :now }

    before { visit seasons_path }

    it { is_expected.to have_css("tr[data-season-id='#{season.id}'].table-success") }
  end

  context 'with a past season' do
    let!(:season) { create :season, start_date: 3.years.ago, end_date: 2.years.ago }

    before { visit seasons_path }

    it { is_expected.to have_css("tr[data-season-id='#{season.id}'].table-secondary") }
  end
end
