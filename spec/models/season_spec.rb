# frozen_string_literal: true

require 'rails_helper'
require_relative 'concerns/date_range'

RSpec.describe Season do
  it_behaves_like 'date_range'

  describe SeasonValidator do
    before do
      create(:season)
    end

    it 'prohibits overlapping seasons' do
      year = Date.today.year
      ranges = [
        (Date.new(year, 1, 1)..Date.new(year, 5, 1)),
        (Date.new(year, 11, 1)..Date.new(year, 12, 1)),
        (Date.new(year, 5, 1)..Date.new(year, 7, 1)),
        (Date.new(year, 1, 1)..Date.new(year, 12, 1))
      ]

      ranges.each do |range|
        other = build(:season, start_date: range.first, end_date: range.last)
        expect(other).to be_invalid
        expect(other.errors[:base].join).to match(/overlaps/)
      end
    end
  end

  describe '#months' do
    let :season do
      create :season,
             start_date: Date.new(2018, 5, 15),
             end_date: Date.new(2018, 9, 15)
    end

    it 'is an array of dates' do
      expect(season.months).to be_an Array
      expect(season.months).to all(be_a Date)
      expect(season.months.map(&:day)).to all(be 1)
    end

    it 'contains the first month' do
      expect(season.months).to include(Date.new(2018, 5, 1))
    end

    it 'contains the last month' do
      expect(season.months).to include(Date.new(2018, 9, 1))
    end

    it 'has the right number of months' do
      expect(season.months.count).to be 5
    end
  end
end
