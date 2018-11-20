# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PDF calendar' do
  let :user do
    create :user
  end
  before :each do
    sign_in(user)
  end

  it 'renders a PDF' do
    create :season, :now
    get events_path(format: 'pdf')
    expect(response.content_type).to eq 'application/pdf'

    cd = response.headers['Content-Disposition']
    expect(cd).to match(/^attachment/)
    expect(cd).to match(/filename="camp_calendar.pdf"/)
  end

  it 'redirects without a current season' do
    get events_path(format: 'pdf')
    expect(response.code).to match(/^3\d\d/)
  end
end
