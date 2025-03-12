# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/cli/commands'

RSpec.describe ClientFinder::CLI::Commands do
  describe '.valid?' do
    it 'returns true for valid commands' do
      expect(described_class.valid?('search')).to be true
      expect(described_class.valid?('find-duplicates')).to be true
      expect(described_class.valid?('help')).to be true
    end

    it 'returns false for invalid commands' do
      expect(described_class.valid?('invalid')).to be false
      expect(described_class.valid?('')).to be false
      expect(described_class.valid?(nil)).to be false
    end
  end

  describe '.available_commands_text' do
    it 'returns formatted string of commands with descriptions' do
      text = described_class.available_commands_text

      expect(text).to include('search: Search clients by name or specific field')
      expect(text).to include('find-duplicates: Find clients with duplicate emails')
      expect(text).to include('help: Show help information')
    end

    it 'formats each command on a new line with proper indentation' do
      lines = described_class.available_commands_text.split("\n")

      expect(lines.all? { |line| line.start_with?('  - ') }).to be true
      expect(lines.size).to eq(described_class::COMMANDS.size)
    end
  end

  describe 'constants' do
    it 'defines expected command constants' do
      expect(described_class::SEARCH).to eq('search')
      expect(described_class::FIND_DUPLICATES).to eq('find-duplicates')
      expect(described_class::HELP).to eq('help')
    end

    it 'includes all commands in COMMANDS array' do
      expect(described_class::COMMANDS).to contain_exactly('search', 'find-duplicates', 'help')
    end

    it 'provides descriptions for all commands' do
      described_class::COMMANDS.each do |command|
        expect(described_class::DESCRIPTIONS).to have_key(command)
        expect(described_class::DESCRIPTIONS[command]).to be_a(String)
        expect(described_class::DESCRIPTIONS[command]).not_to be_empty
      end
    end
  end
end
