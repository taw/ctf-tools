class MD4
  class << self
    def padding(message)
      byte_size = message.bytesize
      extra_zeroes = -(byte_size + 9) % 64
      "\x80".b + "\x00".b * extra_zeroes + [byte_size * 8].pack("Q<")
    end

    def rotate_left(v, s)
      mask = (1 << 32) - 1
      (v << s).&(mask) | (v.&(mask) >> (32 - s))
    end

    def reduce(state, chunk)
      x = chunk.unpack("V*")
      mask = (1 << 32) - 1

      a, b, c, d = state
      aa, bb, cc, dd = a, b, c, d

      rotations = [
        3,7,11,19, 3,7,11,19, 3,7,11,19, 3,7,11,19,
        3,5,9,13, 3,5,9,13, 3,5,9,13, 3,5,9,13,
        3,9,11,15, 3,9,11,15, 3,9,11,15, 3,9,11,15,
      ]
      schedule = [
        0,1,2,3, 4,5,6,7, 8,9,10,11, 12,13,14,15,
        0,4,8,12, 1,5,9,13, 2,6,10,14, 3,7,11,15,
        0,8,4,12, 2,10,6,14, 1,9,5,13, 3,11,7,15,
      ]

      48.times do |j|
        xi = x[schedule[j]]
        ri = rotations[j]
        if j <= 15
          u = b & c | (b ^ mask) & d
          k = 0
        elsif j <= 31
          u = b & c | b & d | c & d
          k = 0x5a827999
        else
          u = b ^ c ^ d
          k = 0x6ed9eba1
        end
        t = rotate_left(a + u + xi + k, ri)
        a, b, c, d = d, t, b, c
      end

      [
        (a + aa) & mask,
        (b + bb) & mask,
        (c + cc) & mask,
        (d + dd) & mask,
      ]
    end

    def initial_state
      [0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476]
    end

    def finalize(state)
      state.pack("V4").unpack("H*")[0]
    end

    def hexdigest(message)
      padded = message.b + padding(message)
      chunks = (0...padded.size).step(64).map{|i| padded[i, 64] }
      state = chunks.reduce(initial_state) do |state, chunk|
        reduce(state, chunk)
      end
      finalize(state)
    end
  end
end
