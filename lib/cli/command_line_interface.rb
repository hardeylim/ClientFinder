# frozen_string_literal: true

require_relative '../repository/client_repository'
require_relative '../services/search_service'
require_relative '../services/duplicate_finder_service'
require_relative '../services/ratings_service'
require_relative 'commands'

module ClientFinder
  module CLI
    # Command Line Interface for the ClientFinder application
    class CommandLineInterface
      def initialize

      end

      # Run the CLI application
      def run(args)
        if args.empty?
          puts 'Error: No command provided'
          show_help
          return
        end

        command = args[0]
        source = args[2]
        initialize_repo(source)

        unless Commands.valid?(command)
          puts "Error: Invalid command '#{command}'"
          puts "\nAvailable commands:"
          puts Commands.available_commands_text
          return
        end

        case command
        when Commands::SEARCH
          handle_search(args[1..])
        when Commands::FIND_DUPLICATES
          handle_find_duplicates
        when Commands::RATINGS
          handle_search_by_ratings(args[1..])
        when Commands::HELP
          show_help
        end
      end

      private

      def initialize_repo(source)
        @repository = Repository::ClientJsonFileRepository.new(source)
        @search_service = Services::SearchService.new(@repository)
        @duplicate_finder_service = Services::DuplicateFinderService.new(@repository)
        @ratings_service = Services::RatingsService.new(@repository)
      end

      # Handle the search command
      def handle_search(args)
        if args.empty?
          puts "Error: Missing search query. Use 'search <query>'."
          return
        end

        query = args[0]

        # Check if we're searching by a specific field
        if args.size >= 3 && args[1] == '--field'
          field = args[2]
          results = @search_service.search_by_field(field, query)
          display_search_results(results, "Searching for '#{query}' in field '#{field}'")
        else
          # Default to searching by name
          results = @search_service.search_by_name(query)
          display_search_results(results, "Searching for name containing '#{query}'")
        end
      end

      def handle_search_by_ratings(args)
        if args.empty? || !args[0].match?(/^\d*\.?\d+$/)
          puts "Error: Invalid rating. Please provide a numeric rating (e.g., '3.5')."
          return
        end

        rating = args[0]
        results = @ratings_service.search_by_rating(rating)
        display_search_results(results, "Finding staff with rating >= #{rating}")
      end

      # Handle the find-duplicates command
      def handle_find_duplicates
        puts @duplicate_finder_service.format_duplicate_emails
      end

      # Display search results
      def display_search_results(results, header)
        puts header
        puts "Found #{results.size} result(s):"

        if results.empty?
          puts 'No records found matching your query.'
        else
          results.each do |record|
            puts format_record(record)
          end
        end
      end

      def format_record(record)
        fields = record.map { |key, value| "#{key}: #{value}" }.join(", ")
        "[Record] #{fields}"
      end

      # Show help information
      def show_help
        puts <<~HELP
          ClientFinder - A tool for managing client data

          Available commands:
          #{Commands.available_commands_text}

          Usage examples:
            #{Commands::SEARCH} <query>                    - Search clients by name
            #{Commands::SEARCH} <query> --field <field>    - Search clients by specific field
            #{Commands::FIND_DUPLICATES}                   - Find clients with duplicate emails
            #{Commands::RATINGS} <rating>                  - Find staff with rating >= value
            #{Commands::HELP}                              - Show this help message

          Examples:
            client_finder #{Commands::SEARCH} "John"
            client_finder #{Commands::SEARCH} "john.doe@gmail.com" --field email
            client_finder #{Commands::FIND_DUPLICATES}
            client_finder #{Commands::RATINGS} 3.5 staff
        HELP
      end
    end
  end
end
