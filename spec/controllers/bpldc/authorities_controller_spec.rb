# frozen_string_literal: true

require_relative '../shared/index_shared'
RSpec.describe Bpldc::AuthoritiesController do
  render_views

  describe 'GET various authorities routes' do
    %i(index subjects genres names geographics).each do |authorities_route|
      before(:each) { get authorities_route, format: :json }

      it_behaves_like 'bpldc_index_shared'
    end
  end
end
