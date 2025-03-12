# frozen_string_literal: true

require 'rspec'
require 'tempfile'
require_relative '../../lib/repository/client_repository'

RSpec.describe ClientFinder::Repository::ClientRepository do
  let(:client_data) do
    [
      { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john.doe@example.com' },
      { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => 'jane.smith@example.com' },
      { 'id' => 3, 'full_name' => 'Another John', 'email' => 'another.john@example.com' },
      { 'id' => 4, 'full_name' => 'Duplicate Email', 'email' => 'jane.smith@example.com' }
    ]
  end

  let(:json_file) do
    file = Tempfile.new(['clients', '.json'])
    file.write(JSON.generate(client_data))
    file.close
    file.path
  end

  after do
    File.unlink(json_file) if File.exist?(json_file)
  end

  describe '#initialize' do
    it 'loads from default path when no path provided' do
      allow(File).to receive(:expand_path)
        .with(described_class::DEFAULT_DATA_PATH)
        .and_return(json_file)

      repository = described_class.new
      expect(repository.clients.size).to eq(4)
      expect(repository.clients.first.full_name).to eq('John Doe')
    end

    it 'loads from custom path when provided' do
      custom_path = 'custom/path/data.json'
      allow(File).to receive(:expand_path)
        .with(custom_path)
        .and_return(json_file)

      repository = described_class.new(custom_path)
      expect(repository.clients.size).to eq(4)
      expect(repository.clients.first.full_name).to eq('John Doe')
    end
  end

  describe '#load_from_file' do
    it 'raises an error if the file does not exist' do
      repository = described_class.new(json_file) # Use valid file for initialization
      expect { repository.load_from_file('nonexistent.json') }.to raise_error(/File not found/)
    end
  end

  describe '#search_by_name' do
    let(:repository) do
      repo = ClientFinder::Repository::ClientRepository.new
      repo.load_from_file(json_file)
      repo
    end

    it 'returns clients with names matching the query case-insensitively' do
      results = repository.search_by_name('john')
      
      expect(results.size).to eq(2)
      expect(results.map(&:full_name)).to include('John Doe', 'Another John')
    end

    it 'returns an empty array if no matches are found' do
      results = repository.search_by_name('nonexistent')
      
      expect(results).to be_empty
    end

    it 'returns an empty array if the query is empty' do
      results = repository.search_by_name('')
      
      expect(results).to be_empty
    end
  end

  describe '#find_duplicate_emails' do
    let(:repository) do
      repo = ClientFinder::Repository::ClientRepository.new
      repo.load_from_file(json_file)
      repo
    end

    it 'returns emails that appear more than once' do
      duplicates = repository.find_duplicate_emails
      
      expect(duplicates.size).to eq(1)
      expect(duplicates.keys).to include('jane.smith@example.com')
      expect(duplicates['jane.smith@example.com'].size).to eq(2)
    end
  end
end
