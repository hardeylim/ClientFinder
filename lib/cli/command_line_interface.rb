# frozen_string_literal: true

require_relative '../repository/client_repository'
require_relative '../services/search_service'
require_relative '../services/duplicate_finder_service'
require_relative 'commands'

module ClientFinder
  module CLI
    # Command Line Interface for the ClientFinder application
    class CommandLineInterface
      def initialize
        @repository = Repository::ClientRepository.new
        @search_service = Services::SearchService.new(@repository)
        @duplicate_finder_service = Services::DuplicateFinderService.new(@repository)
      end

      # Run the CLI application
      def run(args)
        if args.empty?
          puts 'Error: No command provided'
          show_help
          return
        end

        command = args[0]

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
        when Commands::HELP
          show_help
        end
      end

      private

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

      # Handle the find-duplicates command
      def handle_find_duplicates
        puts @duplicate_finder_service.format_duplicate_emails
      end

      # Display search results
      def display_search_results(results, header)
        puts header
        puts "Found #{results.size} result(s):"

        if results.empty?
          puts 'No clients found matching your query.'
        else
          results.each do |client|
            puts client
          end
        end
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
            #{Commands::HELP}                              - Show this help message

          Examples:
            client_finder #{Commands::SEARCH} "John"
            client_finder #{Commands::SEARCH} "john.doe@gmail.com" --field email
            client_finder #{Commands::FIND_DUPLICATES}
        HELP
      end
    end
  end
end
