# frozen_string_literal: true

RSpec.describe 'Routes' do
  describe 'Geomash routes' do
    describe 'tgn' do
      it 'routes the tgn url to Geomash#tgn' do
        expect(get: '/geomash/tgn/foo').to route_to(controller: 'geomash/geomash',
                                                    action: 'tgn',
                                                    id: 'foo')
      end
    end

    describe 'geonames' do
      it 'routes the geonames url to Geomash#geonames' do
        expect(get: '/geomash/geonames/foo').to route_to(controller: 'geomash/geomash',
                                                         action: 'geonames',
                                                         id: 'foo')
      end
    end

    describe 'parse' do
      it 'routes the parse url to Geomash#parse' do
        expect(get: '/geomash/parse?term=foo').to route_to(controller: 'geomash/geomash',
                                                           action: 'parse',
                                                           term: 'foo')
      end
    end

    describe 'state_town_lookup' do
      it 'routes the state_town_lookup url to Geomash#state_town_lookup' do
        expect(get: '/geomash/state_town_lookup?term=foo').to route_to(controller: 'geomash/geomash',
                                                                       action: 'state_town_lookup',
                                                                       term: 'foo')
      end
    end
  end
end
