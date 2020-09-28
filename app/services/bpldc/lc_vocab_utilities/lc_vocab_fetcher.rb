# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

module Bpldc
  module LcVocabUtilities
    class LcVocabFetcher
      ##
      # fetch LC vocab data to seed the database for controlled values
      # @param bpldc_class [String] class name, e.g. Bpldc::Role
      # @param lc_url [String] URL of vocab JSON
      # @param skip [Array] any IDs that should not be added to the db (e.g. 'unknown')
      # @param auth_code [String] code attribute from corresponding Bpldc::Authority
      def self.seed_lc_data(bpldc_class: '', lc_url: '', skip: [], auth_code: '')
        return false if bpldc_class.blank? || lc_url.blank? || auth_code.blank?

        puts "Seeding #{bpldc_class} values"
        connection = Faraday.new(lc_url) do |f|
          f.use FaradayMiddleware::FollowRedirects, limit: 3
          f.adapter Faraday.default_adapter
        end
        lc_response = connection.get
        lc_data = lc_response.status == 200 ? JSON.parse(lc_response.body) : nil
        return false unless lc_data

        authority = Bpldc::Authority.where(code: auth_code).first
        return false unless authority

        lc_data.each do |lc_data_hash|
          next unless lc_data_hash['@id'] !~ /\A_:/ &&
                      lc_data_hash['@type'].include?('http://www.loc.gov/mads/rdf/v1#Authority')

          bpldc_class.constantize.transaction do
            begin
              auth_input = { authority_id: authority.id }
              auth_input[:id_from_auth] = lc_data_hash['@id']&.split('/')&.last
              next if skip.include?(auth_input[:id_from_auth])

              auth_labels = lc_data_hash['http://www.loc.gov/mads/rdf/v1#authoritativeLabel']
              auth_labels.each do |auth_label|
                next unless auth_label['@language'] == 'en' || auth_labels.count == 1

                auth_input[:label] = auth_label['@value']&.strip
              end
              bpldc_class.constantize.where(auth_input).first_or_create!
            rescue StandardError => e
              puts "Failed to seed #{bpldc_class} with the following input #{auth_input.inspect}"
              puts e.inspect
            end
          end
        end
      end
    end
  end
end
