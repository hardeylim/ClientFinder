# frozen_string_literal: true

require 'json'
require_relative '../models/client'

module ClientFinder
  module Repository
    # Repository for managing client data
    class ClientRepository
      attr_reader :clients

      DEFAULT_DATA_PATH = File.expand_path('../../data/clients.json', __dir__)

      def initialize(file_path = DEFAULT_DATA_PATH)
        @clients = []
        load_from_file(file_path)
      end

      # Load clients from a JSON file
      def load_from_file(file_path)
        @clients = []
        begin
          full_path = File.expand_path(file_path)
          data = JSON.parse(File.read(full_path))
          @clients = data.map { |client_data| Models::Client.from_hash(client_data) }
        rescue Errno::ENOENT
          raise "File not found: #{file_path}"
        rescue JSON::ParserError
          raise "Invalid JSON format in file: #{file_path}"
        end
      end

      # Search clients by name (case-insensitive partial match)
      def search_by_name(query)
        return [] if query.nil? || query.empty?

        @clients.select do |client|
          client.full_name.downcase.include?(query.downcase)
        end
      end

      # Search clients by any field
      def search_by_field(field, query)
        return [] if query.nil? || query.empty?
        return [] unless client_has_field?(field)

        @clients.select do |client|
          value = client.send(field.to_sym).to_s.downcase
          value.include?(query.downcase)
        end
      end

      # Find duplicate emails
      def find_duplicate_emails
        emails = Hash.new { |hash, key| hash[key] = [] }

        @clients.each do |client|
          emails[client.email.downcase] << client
        end

        # Return only emails that have more than one client
        emails.select { |_email, clients| clients.size > 1 }
      end

      private

      def client_has_field?(field)
        Models::Client.instance_methods.include?(field.to_sym)
      end
    end
  end
end
