# frozen_string_literal: true

require_relative '../shared/index_shared'
RSpec.describe Bpldc::RightsStatementsController do
  render_views

  describe 'GET licenses' do
    before(:each) { get :index, format: :json }

    it_behaves_like 'bpldc_index_shared'
  end
end
