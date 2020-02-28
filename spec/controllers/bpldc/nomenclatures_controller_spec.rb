# frozen_string_literal: true

require_relative '../shared/index_shared'
RSpec.describe Bpldc::NomenclaturesController do
  describe 'GET various nomenclature routes' do
    %i(resource_types roles languages basic_genres).each do |nomenclature_route|
      before(:each) { get nomenclature_route }

      it_behaves_like 'bpldc_index_shared'
    end
  end
end
