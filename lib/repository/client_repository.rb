# frozen_string_literal: true

require 'json'

module ClientFinder
  module Repository
    # Repository for managing client data
    class ClientRepository
      attr_reader :records

      CLIENTS = 'clients'
      STAFF = 'staff'

      DEFAULT_DATA_PATH = File.expand_path('../../data/clients.json', __dir__)
      STAFF_PATH = File.expand_path('../../data/staff.json', __dir__)

      def initialize(source = CLIENTS)
        @records = []
        load_from_file(source)
      end

      # Load clients from a JSON file
      def load_from_file(source)
        puts "Source: #{source}"
        file_path = case source
                    when 'staff'
                      STAFF_PATH
                    else
                      DEFAULT_DATA_PATH
                    end

        @records = []
        begin
          full_path = File.expand_path(file_path)
          data = JSON.parse(File.read(full_path))
          @records = data
        rescue Errno::ENOENT
          raise "File not found: #{file_path}"
        rescue JSON::ParserError
          raise "Invalid JSON format in file: #{file_path}"
        end
      end

      # Search clients by name (case-insensitive partial match)
      def search_by_name(query)
        return [] if query.nil? || query.empty?

        @records.select do |record|
          record['full_name'].to_s.downcase.include?(query.downcase)
        end
      end

      def search_by_rating(query)
        return [] if query.nil?

        @records.select do |record|
          (record['rating'] || 0).to_f >= query
        end
      end

      # Search clients by any field
      def search_by_field(field, query)
        return [] if query.nil? || query.empty?
        return [] unless client_has_field?(field)

        @records.select do |record|
          value = record[field].to_s.downcase
          value.include?(query.downcase)
        end
      end

      # Find duplicate emails
      def find_duplicate_emails
        emails = Hash.new { |hash, key| hash[key] = [] }

        @records.each do |record|
          emails[record['email'].to_s.downcase] << record
        end

        # Return only emails that have more than one client
        emails.select { |_email, clients| clients.size > 1 }
      end

      private

      def client_has_field?(field)
        @records.first&.key?(field) || false
      end
    end
  end
end
