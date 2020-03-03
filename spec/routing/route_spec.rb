# frozen_string_literal: true

RSpec.describe 'Routes' do
  describe 'bpldc routes' do
    describe 'authorities' do
      it 'routes the authorities url to authorities#index' do
        expect(get: '/bpldc/authorities').to route_to(controller: 'bpldc/authorities',
                                                      action: 'index')
      end

      describe 'authorities sub-routes' do
        %w(subjects genres names geographics).each do |subroute|
          describe "authorities/#{subroute}" do
            it "routes the authorities/subjects url to authorities##{subroute}" do
              expect(get: "/bpldc/authorities/#{subroute}").to route_to(controller: 'bpldc/authorities',
                                                                        action: subroute)
            end
          end
        end
      end
    end

    describe 'nomenclatures' do
      %w(basic_genres languages roles resource_types ).each do |nom_route|
        describe nom_route do
          it "routes the #{nom_route} url to nomenclatures##{nom_route}" do
            expect(get: "/bpldc/#{nom_route}").to route_to(controller: 'bpldc/nomenclatures',
                                                           action: nom_route)
          end
        end
      end
    end

    describe 'licenses' do
      it 'routes the licenses url to licenses#index' do
        expect(get: '/bpldc/licenses').to route_to(controller: 'bpldc/licenses', action: 'index')
      end
    end
  end

  describe 'geomash routes' do
    describe 'tgn' do
      it 'routes the tgn url to geomash#tgn' do
        expect(get: '/geomash/tgn/foo').to route_to(controller: 'geomash/geomash',
                                                    action: 'tgn',
                                                    id: 'foo')
      end
    end

    describe 'geonames' do
      it 'routes the geonames url to geomash#geonames' do
        expect(get: '/geomash/geonames/foo').to route_to(controller: 'geomash/geomash',
                                                         action: 'geonames',
                                                         id: 'foo')
      end
    end

    describe 'parse' do
      it 'routes the parse url to geomash#parse' do
        expect(get: '/geomash/parse?term=foo').to route_to(controller: 'geomash/geomash',
                                                           action: 'parse',
                                                           term: 'foo')
      end
    end

    describe 'state_town_lookup' do
      it 'routes the state_town_lookup url to geomash#state_town_lookup' do
        expect(get: '/geomash/state_town_lookup?term=foo').to route_to(controller: 'geomash/geomash',
                                                                       action: 'state_town_lookup',
                                                                       term: 'foo')
      end
    end
  end
end
