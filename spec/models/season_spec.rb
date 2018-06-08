require 'rails_helper'

RSpec.describe Season, :type => :model do
  it_behaves_like "date_range"

  describe SeasonValidator do
    before(:each) do
      create(:season)
    end

    it "prohibits overlapping seasons" do
      ranges = [
        (Date.new(Date.today.year, 1, 1)..Date.new(Date.today.year, 5, 1)),
        (Date.new(Date.today.year, 11, 1)..Date.new(Date.today.year, 12, 1)),
        (Date.new(Date.today.year, 5, 1)..Date.new(Date.today.year, 7, 1)),
        (Date.new(Date.today.year, 1, 1)..Date.new(Date.today.year, 12, 1))
      ]

      ranges.each do |range|
        other = build(:season, start_date: range.first, end_date: range.last)
        expect(other).to be_invalid
        expect(other.errors[:base].join).to match(/overlaps/)
      end
    end
  end
end
