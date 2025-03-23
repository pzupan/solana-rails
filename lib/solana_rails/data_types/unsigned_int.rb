module SolanaRails
  module DataTypes

    class UnsignedInt
      attr_reader :size

      BITS = {
        8 => { directive: 'C', size: 1 },   # 8-bit unsigned integer
        32 => { directive: 'L<', size: 4 }, # 32-bit little-endian unsigned integer
        64 => { directive: 'Q<', size: 8 }  # 64-bit little-endian unsigned integer
      }

      def initialize(bits)
        @bits = bits
        type = BITS[@bits]
        raise "must_be_one_of_the_supported_sizes_[#{BITS.keys.join('/')}]_bits" unless type
        @size = type[:size]
        @directive = type[:directive]
      end

      def serialize(obj)
        raise "must_be_an_integer" unless obj.is_a?(Integer)
        raise "must_be_greater_than_or_equal_zero" if obj.negative?

        if obj >= 256**@size
          raise "integer_to_large_to_fit_in_#{@size}_bytes"
        end

        [obj].pack(@directive).bytes
      end

      # Deserialize bytes into the unsigned integer
      def deserialize(bytes)
        raise "invalid_expected_#{@size}_bytes_got_#{bytes.size})_bytes" if bytes.size != @size

        bytes.pack('C*').unpack(@directive).first
      end
    end

  end
end
