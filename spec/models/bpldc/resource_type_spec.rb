# frozen_string_literal: true

require_relative './shared/nomenclatures'
RSpec.describe Bpldc::ResourceType do
  subject { create(:bpldc_resource_type) }

  it_behaves_like 'nomenclature'

  describe 'associations' do
    it { is_expected.to belong_to(:authority).
        inverse_of(:resource_types).
        class_name('Bpldc::Authority').
        required }
  end
end
