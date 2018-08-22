module Gimli
  class <<self
    # This would use a lot fewer conversions with classical padding
    def hexdigest(message)
      message = message.b
      rate = 16
      state = [0] * (12*4)

      # Absorb
      i = 0
      block_size = 0
      while i < message.size
        block = message[i, 16].unpack("C*")
        block_size = block.size
        (0...block_size).each do |i|
          state[i] ^= block[i]
        end

        i += block_size

        if block_size == rate
          state = gimli_u8ary(state)
          block_size = 0
        end
      end

      # Padding
      state[block_size] ^= 0x1f
      state[rate - 1] ^= 0x80

      state = gimli_u8ary(state)

      output = ""
      output_len = 32

      # Squeeze
      while output_len > 0
        block_size = [output_len, rate].min
        block = state.pack("C*")[0, block_size]
        output << block.to_hex
        output_len -= block_size

        if output_len > 0
          state = gimli_u8ary(state)
        end
      end

      output
    end

    private def rotate(x, b)
      nb = (32 - b)
      ( (x << b) | (x >> nb) ) & 0xffff_ffff
    end

    def gimli_u8ary(state)
      raise unless state.size == 12*4
      state = state.pack("C48").unpack("V12")
      state = gimli(state)
      state.pack("V12").unpack("C48")
    end

    def gimli(state)
      raise unless state.size == 12
      state = state.dup

      (1..24).to_a.reverse.each do |round|
        (0..3).each do |column|
          x = rotate(state[    column], 24)
          y = rotate(state[4 + column], 9)
          z =        state[8 + column]
          state[8 + column] = (x ^ (z << 1) ^ ((y&z) << 2)) & 0xffff_ffff
          state[4 + column] = (y ^ x ^ ((x|z) << 1)) & 0xffff_ffff
          state[    column] = (z ^ y ^ ((x&y) << 3)) & 0xffff_ffff
        end

        if (round & 3) == 0
          state[0], state[1] = state[1], state[0]
          state[2], state[3] = state[3], state[2]
        end

        if (round & 3) == 2
          state[0], state[2] = state[2], state[0]
          state[1], state[3] = state[3], state[1]
        end

        if (round & 3) == 0
          state[0] ^= (0x9e37_7900 | round)
        end
      end

      state
    end
  end
end
