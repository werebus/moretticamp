# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PDF calendar' do
  let(:user) { create :user }

  before { sign_in(user) }

  context 'with a current season' do
    let(:content_disposition) { response.headers['Content-Disposition'] }

    before do
      create :season, :now
      get events_path(format: 'pdf')
    end

    it 'is a pdf' do
      expect(response.media_type).to eq 'application/pdf'
    end

    it 'is an attachment' do
      expect(content_disposition).to match(/^attachment/)
    end

    it 'specifies a file name' do
      expect(content_disposition).to match(/filename="camp_calendar.pdf"/)
    end
  end

  context 'without a current season' do
    before { get events_path(format: 'pdf') }

    it 'redirects' do
      expect(response.code).to match(/^3\d\d/)
    end
  end
end
