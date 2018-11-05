# frozen_string_literal: true

require 'rails_helper'
require_relative '../concerns/date_range'

RSpec.describe Event do
  it_behaves_like 'date_range'

  describe EventSeasonValidator do
    context 'without a season' do
      it 'requires an existing season' do
        event = build(:event)
        expect(event).to_not be_valid
        expect(event.errors[:base].join).to match(/no season/)
      end
    end
    context 'with a season' do
      before(:each) do
        create(:season)
        @season_start = Season.current_or_next.start_date
        @season_end = Season.current_or_next.end_date
      end

      it 'requires events to not start before the current season' do
        event = build(:event,
                      start_date: @season_start - 1.day,
                      end_date: @season_start + 2.days)
        expect(event).to_not be_valid
        expect(event.errors[:base].join).to match(/occur durring/)
      end
      it 'requires events to not end after the current season' do
        event = build(:event,
                      start_date: @season_start + 1.day,
                      end_date: @season_end + 1.day)
        expect(event).to_not be_valid
        expect(event.errors[:base].join).to match(/occur durring/)
      end
      it 'allows events within the season' do
        event = build(:event,
                      start_date: @season_start + 1.day,
                      end_date: @season_end - 1.day)
        expect(event).to be_valid
      end
    end
  end

  describe '.ical' do
    before :each do
      create :season
    end
    let! :events do
      create_list :event, 5
    end
    let :ical_lines do
      Event.ical.to_ical.split("\r\n")
    end

    it 'has a prodid' do
      expect(ical_lines).to include('PRODID:-//wereb.us//moretti.camp//EN')
    end
    it 'has a VEVENT for every event' do
      expect(ical_lines.count('BEGIN:VEVENT')).to be 5
    end
    it 'can be given a subset of events' do
      lines = Event.ical(events[0,2]).to_ical.split("\r\n")
      expect(lines.count('BEGIN:VEVENT')).to be 2
    end
  end

  describe '#display_title' do
    it 'shows a title if present' do
      expect(build(:event, :titled).display_title).to match(/Fun/)
      expect(build(:event, :titled, :unowned).display_title).to match(/Fun/)
    end
    it "shows the user's first name if no title" do
      event = build(:event)
      expect(event.display_title).to eql(event.user.first_name)
    end
    it 'has an empty title if nothing else' do
      expect(build(:event, :unowned).display_title).to be_blank
    end
  end

  describe '#full_title' do
    let :event do
      build :event
    end

    it 'contains the display_title' do
      expect(event.full_title).to include(event.display_title)
    end
    it 'contains the start and end dates' do
      expect(event.full_title).to include(event.start_date.strftime('%b'))
      expect(event.full_title).to include(event.end_date.strftime('%b'))
    end
  end

  describe '#ical' do
    before :each do
      create :season
    end
    let :event do
      create :event, description: 'Toasty'
    end
    let :ical_lines do
      event.ical.to_ical.split("\r\n")
    end
    let :created_stamp do
      event.created_at.utc.strftime('%Y%m%dT%H%M%SZ')
    end
    let :updated_stamp do
      event.updated_at.utc.strftime('%Y%m%dT%H%M%SZ')
    end

    it 'has a UID' do
      expect(ical_lines).to include("UID:#{event.id}@moretti.camp")
    end
    it 'is CONFIRMED' do
      expect(ical_lines).to include('STATUS:CONFIRMED')
    end
    it 'has a start and end date' do
      start_string = event.start_date.strftime('%Y%m%d')
      end_string = (event.end_date + 1.day).strftime('%Y%m%d')
      expect(ical_lines).to include("DTSTART;VALUE=DATE:#{start_string}")
      expect(ical_lines).to include("DTEND;VALUE=DATE:#{end_string}")
    end
    it 'has a summary' do
      expect(ical_lines).to include("SUMMARY:#{event.display_title}")
    end
    it 'has a description' do
      expect(ical_lines).to include('DESCRIPTION:Toasty')
    end
    it 'has timestamps' do
      expect(ical_lines).to include("DTSTAMP:#{created_stamp}")
      expect(ical_lines).to include("LAST-MODIFIED:#{updated_stamp}")
    end
  end
end
