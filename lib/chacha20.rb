class Chacha20
  class << self
    CONST_32 = "expand 32-byte k".unpack("C*")
    CONST_16 = "expand 16-byte k".unpack("C*")

    def rotate_left(x, s)
      ((x >> (32 - s)) ^ (x << s)) & 0xFFFF_FFFF
    end

    def quarterround(a, b, c, d)
      a = (a + b) & 0xFFFF_FFFF
      d ^= a
      d = rotate_left(d, 16)
      c = (c + d) & 0xFFFF_FFFF
      b ^= c
      b = rotate_left(b, 12)
      a = (a + b) & 0xFFFF_FFFF
      d ^= a
      d = rotate_left(d, 8)
      c = (c + d) & 0xFFFF_FFFF
      b ^= c
      b = rotate_left(b, 7)
      [a, b, c, d]
    end

    def doubleround(x)
      x = x.dup
      x[ 0], x[ 4], x[ 8], x[12] = quarterround(x[ 0], x[ 4], x[ 8], x[12])
      x[ 1], x[ 5], x[ 9], x[13] = quarterround(x[ 1], x[ 5], x[ 9], x[13])
      x[ 2], x[ 6], x[10], x[14] = quarterround(x[ 2], x[ 6], x[10], x[14])
      x[ 3], x[ 7], x[11], x[15] = quarterround(x[ 3], x[ 7], x[11], x[15])
      x[ 0], x[ 5], x[10], x[15] = quarterround(x[ 0], x[ 5], x[10], x[15])
      x[ 1], x[ 6], x[11], x[12] = quarterround(x[ 1], x[ 6], x[11], x[12])
      x[ 2], x[ 7], x[ 8], x[13] = quarterround(x[ 2], x[ 7], x[ 8], x[13])
      x[ 3], x[ 4], x[ 9], x[14] = quarterround(x[ 3], x[ 4], x[ 9], x[14])
      x
    end

    def chacha20(blocks)
      x = blocks.pack("C*").unpack("V*")
      z = x
      10.times do
        z = doubleround(z)
      end
      16.times do |i|
        z[i] = (z[i] + x[i]) & 0xFFFF_FFFF
      end
      z.pack("V*").unpack("C*")
    end

    def input_block_32(key, counter, iv)
      c = [counter].pack("Q").unpack("C*")
      [*CONST_32, *key, *c, *iv]
    end

    def input_block_16(k, counter, iv)
      c = [counter].pack("Q").unpack("C*")
      [*CONST_16, *k, *k, *c, *iv]
    end

    def chacha20_block_32(key, counter, iv)
      input = input_block_32(key, counter, iv)
      raise unless input.size == 64
      chacha20(input)
    end

    def chacha20_block_16(key, counter, iv)
      input = input_block_16(key, counter, iv)
      raise unless input.size == 64
      chacha20(input)
    end
  end
end
