class SHA1
  class << self
    def leftrotate(value, shift)
      return (((value << shift) | (value >> (32 - shift))) & 0xffffffff)
    end

    def padding(message)
      byte_size = message.bytesize
      extra_zeroes = -(message.size + 9) % 64
      "\x80".b + "\x00".b * extra_zeroes + [message.size*8].pack("Q>")
    end

    def reduce(state, chunk)
      chunk = chunk.unpack("N*")

      (16..79).each do |i|
        chunk << leftrotate((chunk[i-3] ^ chunk[i-8]  ^ chunk[i-14] ^ chunk[i-16]), 1)
      end
      working_vars = state.dup

      80.times do |i|
        if (0 <= i && i <= 19)
          f = ((working_vars[1] & working_vars[2]) | (~working_vars[1] & working_vars[3]))
          k = 0x5A827999
        elsif (20 <= i && i <= 39)
          f = (working_vars[1] ^ working_vars[2] ^ working_vars[3])
          k = 0x6ED9EBA1
        elsif (40 <= i && i <= 59)
          f = ((working_vars[1] & working_vars[2]) | (working_vars[1] & working_vars[3]) | (working_vars[2] & working_vars[3]))
          k = 0x8F1BBCDC
        elsif (60 <= i && i <= 79)
          f = (working_vars[1] ^ working_vars[2] ^ working_vars[3])
          k = 0xCA62C1D6
        end
        # Complete round & Create array of working variables for next round.
        temp = (leftrotate(working_vars[0], 5) + f + working_vars[4] + k + chunk[i]) & 0xffffffff
        working_vars = [temp, working_vars[0], leftrotate(working_vars[1], 30), working_vars[2], working_vars[3]]
      end

      state.zip(working_vars).map{ |a,b| (a+b) & 0xFFFF_FFFF }
    end

    def initial_state
      [0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0]
    end

    def finalize(state)
      ("%08x"*5) % state
    end

    def hexdigest(message)
      padded = message.b + padding(message.b)
      chunks = (0...padded.size).step(64).map{|i| padded[i, 64] }
      state = chunks.reduce(initial_state) do |state, chunk|
        reduce(state, chunk)
      end
      finalize(state)
    end
  end
end
