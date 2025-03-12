# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/models/client'

RSpec.describe ClientFinder::Models::Client do
  let(:client_hash) do
      {
        'id' => 1,
        'full_name' => 'John Doe',
        'email' => 'john.doe@example.com'
      }
  end

  describe '.from_hash' do
    it 'creates a Client instance from a hash' do
      client = ClientFinder::Models::Client.from_hash(client_hash)
      
      expect(client.id).to eq(1)
      expect(client.full_name).to eq('John Doe')
      expect(client.email).to eq('john.doe@example.com')
    end
  end

  describe '#to_hash' do
    it 'converts a Client instance to a hash' do
      client = ClientFinder::Models::Client.new(1, 'John Doe', 'john.doe@example.com')
      hash = client.to_hash
      
      expect(hash['id']).to eq(1)
      expect(hash['full_name']).to eq('John Doe')
      expect(hash['email']).to eq('john.doe@example.com')
    end
  end

  describe '#to_s' do
    it 'returns a string representation of the client' do
      client = ClientFinder::Models::Client.new(1, 'John Doe', 'john.doe@example.com')
      
      expect(client.to_s).to eq('ID: 1, Name: John Doe, Email: john.doe@example.com')
    end
  end
end
