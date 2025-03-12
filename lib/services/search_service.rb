# frozen_string_literal: true

module ClientFinder
  module Services
    # Service for handling search operations
    class SearchService
      def initialize(repository)
        @repository = repository
      end

      # Search clients by name
      def search_by_name(query)
        @repository.search_by_name(query)
      end

      # Flexible search by any field
      def search_by_field(field, query)
        @repository.search_by_field(field, query)
      end
    end
  end
end
