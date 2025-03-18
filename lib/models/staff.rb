# frozen_string_literal: true

module ClientFinder
  module Models
    # Staff model representing a staff member entity
    class Staff
      attr_reader :id, :full_name, :email, :rating

      def initialize(id, full_name, email, rating)
        @id = id
        @full_name = full_name
        @email = email
        @rating = rating.to_f # Convert to float to ensure proper comparison
      end

      # Create a Staff instance from a hash
      def self.from_hash(hash)
        new(
          hash['id'],
          hash['full_name'],
          hash['email'],
          hash['rating']
        )
      end

      # Convert to hash representation
      def to_hash
        {
          'id' => @id,
          'full_name' => @full_name,
          'email' => @email,
          'rating' => @rating
        }
      end

      # String representation of a staff member
      def to_s
        "ID: #{@id}, Name: #{@full_name}, Email: #{@email}, Rating: #{@rating}"
      end
    end
  end
end
