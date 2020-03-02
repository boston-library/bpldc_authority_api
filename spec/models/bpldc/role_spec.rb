# frozen_string_literal: true

require_relative './shared/nomenclatures'
RSpec.describe Bpldc::Role do
  subject { create(:bpldc_role) }

  it_behaves_like 'nomenclature'

  describe 'associations' do
    it { is_expected.to belong_to(:authority).
        inverse_of(:roles).
        class_name('Bpldc::Authority').
        required }
  end
end
