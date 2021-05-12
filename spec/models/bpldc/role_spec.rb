# frozen_string_literal: true

require_relative './shared/nomenclatures'
require_relative './shared/cache_clearable'

RSpec.describe Bpldc::Role do
  subject { create(:bpldc_role) }

  it_behaves_like 'nomenclature'
  it_behaves_like 'cache_clearable'

  describe 'associations' do
    it { is_expected.to belong_to(:authority).
        inverse_of(:roles).
        class_name('Bpldc::Authority').
        touch(true).
        required }
  end
end
