# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'date_range' do
  let(:model) { described_class }
  let(:factory) { model.to_s.underscore.to_sym }

  it 'needs a start and end date' do
    expect(build(factory, start_date: nil)).to_not be_valid
    expect(build(factory, end_date: nil)).to_not be_valid
  end

  it 'needs a positive length' do
    inv = build(factory, start_date: Date.today, end_date: Date.today - 1.day)
    expect(inv).to_not be_valid
    expect(inv.errors[:end_date].join).to match(/be after/)
  end

  context 'with monthly sequence' do
    let(:mar15) { Date.new(Date.today.year, 3, 15) }
    let(:apr1) { Date.new(Date.today.year, 4, 1) }
    let(:may1) { Date.new(Date.today.year, 5, 1) }
    let(:jun1) { Date.new(Date.today.year, 6, 1) }

    before(:each) do
      create(:season) unless described_class == Season
      FactoryBot.reload
      create_list(factory, 5, :sequenced)
    end

    it 'finds the next one after a date' do
      april = model.find_by(start_date: apr1)
      expect(model.next_after(mar15)).to eq april
    end

    it 'can exclude some from the search' do
      april = model.find_by(start_date: apr1)
      may = model.find_by(start_date: may1)
      expect(model.next_after(mar15, april.id)).to eq may
    end

    it 'finds all between two dates' do
      expect(model.between(apr1, jun1).count).to be 3
    end
  end

  it 'finds one occurring today' do
    create(:season) unless model == Season
    create(factory,
           start_date: Date.today - 1.day,
           end_date: Date.today + 1.day)
    expect(model.current).to be
  end
end
