# frozen_string_literal: true

module ClientFinder
  module Services
    # Service for finding duplicates in the client data
    class DuplicateFinderService
      def initialize(repository)
        @repository = repository
      end

      # Find all clients with duplicate emails
      def find_duplicate_emails
        @repository.find_duplicate_emails
      end

      # Format the duplicate results for display
      def format_duplicate_emails
        duplicates = find_duplicate_emails

        if duplicates.empty?
          'No duplicate emails found.'
        else
          result = ["Found #{duplicates.size} duplicate email(s):"]

          duplicates.each do |email, clients|
            result << "\nEmail: #{email}"
            clients.each do |client|
              result << "  - #{client}"
            end
          end

          result.join("\n")
        end
      end
    end
  end
end
