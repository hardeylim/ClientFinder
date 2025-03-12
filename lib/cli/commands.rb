# frozen_string_literal: true

module ClientFinder
  module CLI
    module Commands
      SEARCH = 'search'
      FIND_DUPLICATES = 'find-duplicates'
      HELP = 'help'

      DESCRIPTIONS = {
        SEARCH => 'Search clients by name or specific field',
        FIND_DUPLICATES => 'Find clients with duplicate emails',
        HELP => 'Show help information'
      }.freeze

      COMMANDS = [SEARCH, FIND_DUPLICATES, HELP].freeze

      def self.valid?(command)
        COMMANDS.include?(command)
      end

      def self.available_commands_text
        COMMANDS.map { |cmd| "  - #{cmd}: #{DESCRIPTIONS[cmd]}" }.join("\n")
      end
    end
  end
end
