# frozen_string_literal: true

Rails.application.routes.draw do
  mount Qa::Engine => '/qa'

  namespace :bpldc do
    get 'authorities', to: 'authorities#index'
    get 'authorities/subjects', to: 'authorities#subjects'
    get 'authorities/genres', to: 'authorities#genres'
    get 'authorities/names', to: 'authorities#names'
    get 'authorities/geographics', to: 'authorities#geographics'
    get 'resource_types', to: 'nomenclatures#resource_types'
    get 'roles', to: 'nomenclatures#roles'
    get 'languages', to: 'nomenclatures#languages'
    get 'basic_genres', to: 'nomenclatures#basic_genres'
    get 'licenses', to: 'licenses#index'
  end

  namespace :geomash do
    get 'tgn/:id', to: 'geomash#tgn'
    get 'geonames/:id', to: 'geomash#geonames'
    get 'parse', to: 'geomash#parse'
    get 'state_town_lookup', to: 'geomash#state_town_lookup'
  end
end
