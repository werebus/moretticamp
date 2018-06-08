require 'rails_helper'

RSpec.describe Event do
  it_behaves_like "date_range"

  describe EventSeasonValidator do
    context "without a season" do
      it "requires an existing season" do
        event = build(:event)
        expect(event).to_not be_valid
        expect(event.errors[:base].join).to match(/no season/)
      end
    end

    context "with a season" do
      before(:each) do
        create(:season)
        @season_start = Season.current_or_next.start_date
        @season_end = Season.current_or_next.end_date
      end

      it "requires events to not start before the current season" do
        event = build(:event, start_date: @season_start - 1.day, end_date: @season_start + 2.days)
        expect(event).to_not be_valid
        expect(event.errors[:base].join).to match(/occur durring/)
      end

      it "requires events to not end after the current season" do
        event = build(:event, start_date: @season_start + 1.day, end_date: @season_end + 1.day)
        expect(event).to_not be_valid
        expect(event.errors[:base].join).to match(/occur durring/)
      end

      it "allows events within the season" do
        event = build(:event, start_date: @season_start + 1.day, end_date: @season_end - 1.day)
        expect(event).to be_valid
      end
    end
  end

  describe "#display_title" do
    it "shows a title if present" do
      expect(build(:event, :titled).display_title).to match(/Fun/)
      expect(build(:event, :titled, :unowned).display_title).to match(/Fun/)
    end

    it "shows the user's first name if no title" do
      event = build(:event)
      expect(event.display_title).to eql(event.user.first_name)
    end

    it "has an empty title if nothing else" do
      expect(build(:event, :unowned).display_title).to eql ''
    end
  end
end
