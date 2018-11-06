class Salsa20
  class << self
    CONST_32_0 = [101, 120, 112,  97]
    CONST_32_1 = [110, 100,  32,  51]
    CONST_32_2 = [ 50,  45,  98, 121]
    CONST_32_3 = [116, 101,  32, 107]

    CONST_16_0 = [101, 120, 112,  97]
    CONST_16_1 = [110, 100,  32,  49]
    CONST_16_2 = [ 54,  45,  98, 121]
    CONST_16_3 = [116, 101,  32, 107]

    def rotate_left(x, s)
      ((x >> (32 - s)) ^ (x << s)) & 0xFFFF_FFFF
    end

    def quarterround(y0, y1, y2, y3)
      z1 = y1 ^ rotate_left((y0 + y3) & 0xFFFF_FFFF, 7)
      z2 = y2 ^ rotate_left((z1 + y0) & 0xFFFF_FFFF, 9)
      z3 = y3 ^ rotate_left((z2 + z1) & 0xFFFF_FFFF, 13)
      z0 = y0 ^ rotate_left((z3 + z2) & 0xFFFF_FFFF, 18)
      [z0, z1, z2, z3]
    end

    def rowround(y)
      z = [nil] * 16
      z[ 0], z[ 1], z[ 2], z[ 3] = quarterround(y[ 0], y[ 1], y[ 2], y[ 3])
      z[ 5], z[ 6], z[ 7], z[ 4] = quarterround(y[ 5], y[ 6], y[ 7], y[ 4])
      z[10], z[11], z[ 8], z[ 9] = quarterround(y[10], y[11], y[ 8], y[ 9])
      z[15], z[12], z[13], z[14] = quarterround(y[15], y[12], y[13], y[14])
      z
    end

    def columnround(x)
      y = [nil] * 16
      y[ 0], y[ 4], y[ 8], y[12] = quarterround(x[ 0], x[ 4], x[ 8], x[12])
      y[ 5], y[ 9], y[13], y[ 1] = quarterround(x[ 5], x[ 9], x[13], x[ 1])
      y[10], y[14], y[ 2], y[ 6] = quarterround(x[10], x[14], x[ 2], x[ 6])
      y[15], y[ 3], y[ 7], y[11] = quarterround(x[15], x[ 3], x[ 7], x[11])
      y
    end

    def doubleround(state)
      rowround(columnround(state))
    end

    def salsa20(blocks)
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

    def input_block_32(k0, k1, n)
      [*CONST_32_0, *k0, *CONST_32_1, *n, *CONST_32_2, *k1, *CONST_32_3]
    end

    def input_block_16(k, n)
      [*CONST_16_0, *k, *CONST_16_1, *n, *CONST_16_2, *k, *CONST_16_3]
    end

    def salsa20_block_32(k0, k1, n)
      input = input_block_32(k0, k1, n)
      salsa20(input)
    end

    def salsa20_block_16(k, n)
      input = input_block_16(k, n)
      salsa20(input)
    end
  end
end
