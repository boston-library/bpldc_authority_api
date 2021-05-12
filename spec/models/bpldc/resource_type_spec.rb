# frozen_string_literal: true

require_relative './shared/nomenclatures'
require_relative './shared/cache_clearable'

RSpec.describe Bpldc::ResourceType do
  subject { create(:bpldc_resource_type) }

  it_behaves_like 'nomenclature'
  it_behaves_like 'cache_clearable'

  describe 'associations' do
    it { is_expected.to belong_to(:authority).
        inverse_of(:resource_types).
        class_name('Bpldc::Authority').
        touch(true).
        required }
  end
end
