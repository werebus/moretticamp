# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Index page' do
  it 'sends you to login if you aren\'t' do
    get '/'
    expect(response).to redirect_to(new_user_session_path)
  end

  it 'displays the events index' do
    sign_in(create(:user))
    get '/'
    expect(response).to have_http_status(:ok)
    expect(response.body).to match(/Season Not Open/)
  end
end
