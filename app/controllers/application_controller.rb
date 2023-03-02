# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::ImplicitRender
  include ActionView::Layouts
  include ActionController::Caching
  include ActionController::MimeResponds

  APP_INFO = {
    app_name: 'bpldc_authority_api',
    organization: 'Lincoln Public Library',
    version: '1.0',
  }.freeze

  def app_info
    render json: Oj.dump(APP_INFO), status: :ok
  end
end
