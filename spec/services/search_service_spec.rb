# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/services/search_service'

RSpec.describe ClientFinder::Services::SearchService do
  let(:repository) { instance_double('ClientFinder::Repository::ClientRepository') }
  let(:service) { described_class.new(repository) }

  describe '#search_by_name' do
    it 'delegates to repository search_by_name' do
      query = 'John'
      expected_results = ['mock result']
      
      expect(repository).to receive(:search_by_name).with(query).and_return(expected_results)
      
      results = service.search_by_name(query)
      expect(results).to eq(expected_results)
    end
  end

  describe '#search_by_field' do
    it 'delegates to repository search_by_field' do
      field = 'email'
      query = 'example.com'
      expected_results = ['mock result']
      
      expect(repository).to receive(:search_by_field).with(field, query).and_return(expected_results)
      
      results = service.search_by_field(field, query)
      expect(results).to eq(expected_results)
    end
  end
end
