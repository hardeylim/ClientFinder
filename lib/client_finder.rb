# frozen_string_literal: true

require_relative 'models/client'
require_relative 'repository/client_repository'
require_relative 'services/search_service'
require_relative 'services/duplicate_finder_service'
require_relative 'cli/command_line_interface'

module ClientFinder
  class << self
    attr_accessor :config

    def configure
      @config ||= Configuration.new
      yield(@config) if block_given?
    end
  end

  class Configuration
    attr_accessor :data_path

    def initialize
    end
  end

  # Version of the application
  VERSION = '1.0.0'
end
