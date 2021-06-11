# frozen_string_literal: true

RSpec.describe ApplicationController do
  render_views

  describe 'GET app_info' do
    it 'renders the app_info response' do
      get :app_info
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).length).to be > 1
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end
end
