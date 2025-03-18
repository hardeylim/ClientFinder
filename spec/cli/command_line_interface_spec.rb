# frozen_string_literal: true

require 'rspec'
require 'stringio'
require_relative '../../lib/cli/command_line_interface'

RSpec.describe ClientFinder::CLI::CommandLineInterface do
  let(:repository) { instance_double('ClientFinder::Repository::ClientRepository') }
  let(:search_service) { instance_double('ClientFinder::Services::SearchService') }
  let(:duplicate_finder_service) { instance_double('ClientFinder::Services::DuplicateFinderService') }
  let(:cli) { described_class.new }  # No longer needs a path parameter

  before do
    # Repository is initialized with default path
    allow(ClientFinder::Repository::ClientJsonFileRepository).to receive(:new)
      .with(no_args)
      .and_return(repository)
    allow(ClientFinder::Services::SearchService).to receive(:new).and_return(search_service)
    allow(ClientFinder::Services::DuplicateFinderService).to receive(:new).and_return(duplicate_finder_service)
    # Redirect stdout for testing output
    @original_stdout = $stdout
    @stdout_stringio = StringIO.new
    $stdout = @stdout_stringio
  end

  after do
    $stdout = @original_stdout
  end

  describe '#run' do
    context 'with no arguments' do
      it 'shows error and help message' do
        cli.run([])

        output = @stdout_stringio.string
        expect(output).to include('Error: No command provided')
        expect(output).to include('Available commands:')
        expect(output).to include('Usage examples:')
      end
    end

    context 'with invalid command' do
      it 'shows error with available commands' do
        cli.run(['invalid'])

        output = @stdout_stringio.string
        expect(output).to include("Error: Invalid command 'invalid'")
        expect(output).to include('Available commands:')
      end
    end

    context 'with search command' do
      it 'handles search with no query' do
        cli.run(['search'])

        output = @stdout_stringio.string
        expect(output).to include("Error: Missing search query. Use 'search <query>'.")
      end

      it 'performs name search' do
        query = 'John'
        results = [
          ClientFinder::Models::Client.new(1, 'John Doe', 'john@example.com')
        ]

        expect(search_service).to receive(:search_by_name)
          .with(query)
          .and_return(results)

        cli.run(['search', query])

        output = @stdout_stringio.string
        expect(output).to include("Searching for name containing '#{query}'")
        expect(output).to include('Found 1 result(s):')
        expect(output).to include('John Doe')
      end

      it 'performs field search' do
        query = 'example.com'
        field = 'email'
        results = [
          ClientFinder::Models::Client.new(1, 'John Doe', 'john@example.com')
        ]

        expect(search_service).to receive(:search_by_field)
          .with(field, query)
          .and_return(results)

        cli.run(['search', query, '--field', field])

        output = @stdout_stringio.string
        expect(output).to include("Searching for '#{query}' in field '#{field}'")
        expect(output).to include('Found 1 result(s):')
        expect(output).to include('john@example.com')
      end
    end

    context 'with find-duplicates command' do
      it 'delegates to duplicate finder service' do
        expect(duplicate_finder_service).to receive(:format_duplicate_emails)
          .and_return('Duplicate emails found...')

        cli.run(['find-duplicates'])

        output = @stdout_stringio.string
        expect(output).to include('Duplicate emails found...')
      end
    end

    context 'with help command' do
      it 'displays help information' do
        cli.run(['help'])

        output = @stdout_stringio.string
        expect(output).to include('ClientFinder - A tool for managing client data')
        expect(output).to include('Available commands:')
        expect(output).to include('Usage examples:')
      end
    end
  end
end
