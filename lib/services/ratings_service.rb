# frozen_string_literal: true

module ClientFinder
  module Services
    # Service for handling rating-based operations
    class RatingsService
      def initialize(repository)
        @repository = repository
      end

      # Search by rating (finds records with rating >= query)
      def search_by_rating(query)
        return [] if query.nil? || query.empty?
        
        rating = query.to_f
        @repository.search_by_rating(rating)
      end
    end
  end
end
