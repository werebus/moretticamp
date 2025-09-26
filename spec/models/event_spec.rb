# frozen_string_literal: true

require 'rails_helper'
require_relative 'concerns/date_range'

RSpec.describe Event do
  it_behaves_like 'date_range'

  describe Event::SeasonValidator do
    context 'without a season' do
      it 'is invalid' do
        expect(build(:event)).not_to be_valid
      end

      it 'adds errors to base' do
        event = build :event
        event.validate
        expect(event.errors[:base].join).to match(/no current available season/)
      end
    end

    context 'with a season' do
      let(:season_start) { Season.current_or_next.start_date }
      let(:season_end) { Season.current_or_next.end_date }

      before { create :season }

      it 'requires events to not start before the current season' do
        event = build :event, start_date: season_start - 1.day,
                              end_date: season_start + 2.days
        expect(event).not_to be_valid
      end

      it 'requires events to not end after the current season' do
        event = build :event, start_date: season_start + 1.day,
                              end_date: season_end + 1.day
        expect(event).not_to be_valid
      end

      it 'allows events within the season' do
        event = build :event, start_date: season_start + 1.day,
                              end_date: season_end - 1.day
        expect(event).to be_valid
      end

      it 'puts an error on base' do
        event = build :event, start_date: season_start - 1.day,
                              end_date: season_start + 2.days
        event.validate
        expect(event.errors[:base].join).to match(/occur durring/)
      end
    end
  end

  describe '.ical' do
    subject(:ical_lines) { described_class.ical.to_ical.split("\r\n") }

    before { create :season }

    let!(:events) { create_list :event, 5 }

    it { is_expected.to include('PRODID:-//wereb.us//moretti.camp//EN') }

    it 'has a VEVENT for every event' do
      expect(ical_lines.count('BEGIN:VEVENT')).to be 5
    end

    it 'can be given a subset of events' do
      lines = described_class.ical(events[0, 2]).to_ical.split("\r\n")
      expect(lines.count('BEGIN:VEVENT')).to be 2
    end
  end

  describe '#display_title' do
    it 'shows a title if it is present and there is no user' do
      expect(build(:event, :titled, :unowned).display_title).to match(/Fun/)
    end

    it 'shows a title if it is present even if there is a user' do
      expect(build(:event, :titled).display_title).to match(/Fun/)
    end

    it "shows the user's first name if no title" do
      event = build :event
      expect(event.display_title).to eql(event.user.first_name)
    end

    it 'has an empty title if nothing else' do
      expect(build(:event, :unowned).display_title).to be_blank
    end
  end

  describe '#full_title' do
    subject(:call) { event.full_title }

    let(:event) { build :event }

    it { is_expected.to include(event.display_title) }

    it { is_expected.to include(event.start_date.strftime('%b')) }

    it { is_expected.to include(event.end_date.strftime('%b')) }
  end

  describe '#ical' do
    subject(:ical_lines) { event.ical.to_ical.split("\r\n") }

    before { create :season }

    let(:event) { create :event, description: 'Toasty' }

    it { is_expected.to include("UID:#{event.id}@moretti.camp") }

    it { is_expected.to include('STATUS:CONFIRMED') }

    it 'has a start date' do
      start_string = event.start_date.strftime('%Y%m%d')
      expect(ical_lines).to include("DTSTART;VALUE=DATE:#{start_string}")
    end

    it 'has an end date' do
      end_string = (event.end_date + 1.day).strftime('%Y%m%d')
      expect(ical_lines).to include("DTEND;VALUE=DATE:#{end_string}")
    end

    it { is_expected.to include("SUMMARY:#{event.display_title}") }

    it { is_expected.to include('DESCRIPTION:Toasty') }

    it 'has a created timestamp' do
      created_stamp = event.created_at.utc.strftime('%Y%m%dT%H%M%SZ')
      expect(ical_lines).to include("DTSTAMP:#{created_stamp}")
    end

    it 'has an updated timestamp' do
      updated_stamp = event.updated_at.utc.strftime('%Y%m%dT%H%M%SZ')
      expect(ical_lines).to include("LAST-MODIFIED:#{updated_stamp}")
    end
  end
end
