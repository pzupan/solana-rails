module SolanaRails
  module DataTypes

    class Blob
      attr_reader :size

      def initialize(size)
        raise ArgumentError, "integer_must_be_greater_than_zero" unless size.is_a?(Integer) && size > 0
        @size = size
      end

      def serialize(obj)
        # Ensure obj is an array and then convert to byte array
        obj = [obj] unless obj.is_a?(Array)
        raise ArgumentError, "object_must_be_an_array_of_bytes" unless obj.all? { |e| e.is_a?(Integer) && e.between?(0, 255) }

        obj.pack('C*').bytes
      end

      def deserialize(bytes)
        # Ensure the byte array is of the correct size
        raise ArgumentError, "byte_array_size_must_match_expected_size" unless bytes.length == @size

        bytes.pack('C*')
      end
    end

  end
end
