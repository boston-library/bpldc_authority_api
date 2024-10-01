# frozen_string_literal: true

Rails.application.routes.draw do
  root 'application#app_info'

  get 'up' => 'rails/health#show', as: :rails_health_check

  mount Qa::Engine => '/qa'

  namespace :bpldc, defaults: { format: 'json' } do
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
    get 'rights_statements', to: 'rights_statements#index'
  end

  namespace :geomash, defaults: { format: 'json' } do
    get 'tgn/:id', to: 'geomash#tgn'
    get 'geonames/:id', to: 'geomash#geonames'
    get 'parse', to: 'geomash#parse'
    get 'state_town_lookup', to: 'geomash#state_town_lookup'
  end
end
