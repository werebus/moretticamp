# frozen_string_literal: true

require 'rails_helper'
require_relative 'concerns/date_range'

RSpec.describe Season do
  it_behaves_like 'date_range'

  describe SeasonValidator do
    let(:other) do
      start_date = Time.zone.now.change(month: 3).to_date
      end_date = Time.zone.now.change(month: 10).to_date
      build :season, start_date:, end_date:
    end

    before { create :season }

    it 'prohibits overlapping seasons' do
      expect(other).not_to be_valid
    end

    it 'adds errors to base' do
      other.validate
      expect(other.errors[:base].join).to match(/overlaps/)
    end
  end

  describe '#months' do
    subject :months do
      build(:season, start_date: Date.new(2018, 5, 15),
                     end_date: Date.new(2018, 9, 15)).months
    end

    it { is_expected.to be_an Array }

    it { is_expected.to all(be_a Date) }

    it 'is entirely firsts of the month' do
      expect(months.map(&:day)).to all(be 1)
    end

    it { is_expected.to include(Date.new(2018, 5, 1)) }

    it { is_expected.to include(Date.new(2018, 9, 1)) }

    it 'has the right number of months' do
      expect(months.count).to be 5
    end
  end
end
