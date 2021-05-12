# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Index page' do
  context 'when not logged-in' do
    before { get '/' }

    it 'sends you to log in' do
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in' do
    before do
      sign_in(create(:user))
      get '/'
    end

    it 'allows access' do
      expect(response).to have_http_status(:ok)
    end

    it 'displays the events index' do
      expect(response.body).to match(/Season Not Open/)
    end
  end
end
