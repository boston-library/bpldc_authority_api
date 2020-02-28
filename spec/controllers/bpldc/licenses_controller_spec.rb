# frozen_string_literal: true

require_relative '../shared/index_shared'
RSpec.describe Bpldc::LicensesController do
  describe 'GET licenses' do
    before(:each) { get :index }

    it_behaves_like 'bpldc_index_shared'
  end
end
