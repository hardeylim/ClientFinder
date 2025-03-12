# frozen_string_literal: true

module ClientFinder
  module Models
    # Client model representing a client entity
    class Client
      attr_reader :id, :full_name, :email

      def initialize(id, full_name, email)
        @id = id
        @full_name = full_name
        @email = email
      end

      # Create a Client instance from a hash
      def self.from_hash(hash)
        new(
          hash['id'],
          hash['full_name'],
          hash['email']
        )
      end

      # Convert to hash representation
      def to_hash
        {
          'id' => @id,
          'full_name' => @full_name,
          'email' => @email
        }
      end

      # String representation of a client
      def to_s
        "ID: #{@id}, Name: #{@full_name}, Email: #{@email}"
      end
    end
  end
end
