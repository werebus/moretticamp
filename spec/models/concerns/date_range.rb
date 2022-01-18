# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples_for 'date_range' do
  let(:model) { described_class }
  let(:factory) { model.to_s.underscore.to_sym }

  it 'needs a start date' do
    expect(build(factory, start_date: nil)).to be_invalid
  end

  it 'needs an end date' do
    expect(build(factory, end_date: nil)).to be_invalid
  end

  context 'with an negative length' do
    let(:invalid) do
      build factory, start_date: Date.new(2020, 3, 15),
                     end_date: Date.new(2020, 3, 1)
    end

    it('is invalid') { expect(invalid).to be_invalid }

    it 'adds an error to the end date' do
      invalid.validate
      expect(invalid.errors[:end_date].join).to match(/be on or after/)
    end
  end

  context 'with monthly sequence' do
    let :dates do
      year = Time.zone.today.year
      { mar15: Date.new(year, 3, 15),
        apr1: Date.new(year, 4, 1),
        may1: Date.new(year, 5, 1),
        jun1: Date.new(year, 6, 1) }
    end

    before do
      create(:season) unless described_class == Season
      FactoryBot.reload
      create_list(factory, 5, :sequenced)
    end

    it 'finds the next one after a date' do
      april = model.find_by(start_date: dates[:apr1])
      expect(model.next_after(dates[:mar15])).to eq april
    end

    it 'can exclude some from the search' do
      april = model.find_by(start_date: dates[:apr1])
      may = model.find_by(start_date: dates[:may1])
      expect(model.next_after(dates[:mar15], april.id)).to eq may
    end

    it 'finds all between two dates' do
      expect(model.between(dates[:apr1], dates[:jun1]).count).to be 3
    end
  end

  it 'finds one occurring today' do
    create(:season, :now) unless model == Season
    create(factory, start_date: Time.zone.today - 1.day,
                    end_date: Time.zone.today + 1.day)
    expect(model.current).to be_present
  end

  context 'when formatting date ranges' do
    let(:date_range) { Date.new(2018, 11, 1)..Date.new(2018, 11, 7) }

    let :one_day do
      build factory, start_date: date_range.first, end_date: date_range.first
    end

    let :multi_day do
      build factory, start_date: date_range.first, end_date: date_range.last
    end

    it 'has a date range' do
      expect(multi_day.date_range).to eq date_range
    end

    it 'has a "word" date range with the start date' do
      expect(multi_day.date_range_words).to match(/Nov 1st/)
    end

    it 'has a "word" date range with the end date' do
      expect(multi_day.date_range_words).to match(/Nov 7th/)
    end

    it 'describes a 1-day event as "on" a date' do
      expect(one_day.date_range_readable).to match(/^on \w+, November 1st/)
    end

    it 'describes a multi-day event as "from" the start date' do
      expect(multi_day.date_range_readable).to match(/from \w+, November 1st/)
    end

    it 'describes a multi-day event as "until" the end date' do
      expect(multi_day.date_range_readable).to match(/until \w+, November 7th/)
    end
  end
end
