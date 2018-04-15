require 'rails_helper'

shared_examples_for "date_range" do
  let(:model) { described_class }
  let(:fact) { model.to_s.underscore.to_sym }

  it "needs a start and end date" do
    expect( build( fact, start_date: nil ) ).to_not be_valid
    expect( build( fact, end_date: nil ) ).to_not be_valid
  end

  it "needs a positive length" do
    inv = build( fact, start_date: Date.today, end_date: Date.today - 1.day )
    expect( inv ).to_not be_valid
    expect( inv.errors[:end_date].join ).to match(/be after/)
  end

  context "with monthly sequence" do
    before(:all) do
      Season.delete_all
      create(:season) unless described_class == Season
      described_class.delete_all
      fact = described_class.to_s.underscore.to_sym

      FactoryBot.reload
      create_list(fact, 5, :sequenced)
    end

    it "finds the next one after a date" do
      april = model.where(start_date: Date.new(Date.today.year, 4, 1)).first
      expect( model.next_after(Date.new(Date.today.year, 3, 15)).id ).to equal april.id
    end

    it "can exclude some from the search" do
      april = model.where(start_date: Date.new(Date.today.year, 4, 1)).first
      may = model.where(start_date: Date.new(Date.today.year, 5, 1)).first
      expect( model.next_after( Date.new(Date.today.year, 3, 15), april.id ).id).to equal may.id
    end

    it "finds all between two dates" do
      first_date = Date.new(Date.today.year, 4, 1)
      second_date = Date.new(Date.today.year, 6, 1)
      expect( model.between(first_date, second_date).count ).to eq 3
    end
  end

  it "finds one occurring today" do
    Season.delete_all
    create(:season) unless model == Season
    model.delete_all
    create(fact, start_date: Date.today - 1.day, end_date: Date.today + 1.day)
    expect( model.current ).to be
  end
end
