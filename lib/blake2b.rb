class BLAKE2b
  class << self
    def rotate_right(x, s)
      ((x >> s) ^ (x << (64 - s))) & 0xFFFF_FFFF_FFFF_FFFF
    end

    def zeropad(x)
      x = x.b
      x + "\x00".b * (128 - x.size)
    end

    IV = [
       0x6A09_E667_F3BC_C908,
       0xBB67_AE85_84CA_A73B,
       0x3C6E_F372_FE94_F82B,
       0xA54F_F53A_5F1D_36F1,
       0x510E_527F_ADE6_82D1,
       0x9B05_688C_2B3E_6C1F,
       0x1F83_D9AB_FB41_BD6B,
       0x5BE0_CD19_137E_2179,
    ]

    SIGMA = [
      [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ],
      [ 14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3 ],
      [ 11, 8, 12, 0, 5, 2, 15, 13, 10, 14, 3, 6, 7, 1, 9, 4 ],
      [ 7, 9, 3, 1, 13, 12, 11, 14, 2, 6, 5, 10, 4, 0, 15, 8 ],
      [ 9, 0, 5, 7, 2, 4, 10, 15, 14, 1, 11, 12, 6, 8, 3, 13 ],
      [ 2, 12, 6, 10, 0, 11, 8, 3, 4, 13, 7, 5, 15, 14, 1, 9 ],
      [ 12, 5, 1, 15, 14, 13, 4, 10, 0, 7, 6, 3, 9, 2, 8, 11 ],
      [ 13, 11, 7, 14, 12, 1, 3, 9, 5, 0, 15, 4, 8, 6, 2, 10 ],
      [ 6, 15, 14, 9, 11, 3, 0, 8, 12, 2, 13, 7, 1, 4, 10, 5 ],
      [ 10, 2, 8, 4, 7, 6, 1, 5, 15, 11, 9, 14, 3, 12, 13, 0 ],
      [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ],
      [ 14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3 ],
    ]

    def g(v, a, b, c, d, x, y)
      v[a] = (v[a] + v[b] + x) & 0xFFFF_FFFF_FFFF_FFFF
      v[d] = rotate_right(v[d] ^ v[a], 32)
      v[c] = (v[c] + v[d]) & 0xFFFF_FFFF_FFFF_FFFF
      v[b] = rotate_right(v[b] ^ v[c], 24)
      v[a] = (v[a] + v[b] + y) & 0xFFFF_FFFF_FFFF_FFFF
      v[d] = rotate_right(v[d] ^ v[a], 16)
      v[c] = (v[c] + v[d]) & 0xFFFF_FFFF_FFFF_FFFF
      v[b] = rotate_right(v[b] ^ v[c], 63)
    end

    def compress(context, input, last)
      v = [*context[:h], *IV]
      t = context[:t]
      v[12] ^= t & 0xFFFF_FFFF_FFFF_FFFF
      v[13] ^= (t >> 64) & 0xFFFF_FFFF_FFFF_FFFF
      if last
        v[14] = (~v[14]) & 0xFFFF_FFFF_FFFF_FFFF
      end

      m = input.unpack("Q<16")

      12.times do |i|
        g(v, 0, 4,  8, 12, m[SIGMA[i][ 0]], m[SIGMA[i][ 1]])
        g(v, 1, 5,  9, 13, m[SIGMA[i][ 2]], m[SIGMA[i][ 3]])
        g(v, 2, 6, 10, 14, m[SIGMA[i][ 4]], m[SIGMA[i][ 5]])
        g(v, 3, 7, 11, 15, m[SIGMA[i][ 6]], m[SIGMA[i][ 7]])
        g(v, 0, 5, 10, 15, m[SIGMA[i][ 8]], m[SIGMA[i][ 9]])
        g(v, 1, 6, 11, 12, m[SIGMA[i][10]], m[SIGMA[i][11]])
        g(v, 2, 7,  8, 13, m[SIGMA[i][12]], m[SIGMA[i][13]])
        g(v, 3, 4,  9, 14, m[SIGMA[i][14]], m[SIGMA[i][15]])
      end

      8.times do |i|
        context[:h][i] ^= v[i] ^ v[i + 8]
      end
    end

    def init(outlen, key)
      raise unless outlen > 0 and outlen <= 64
      raise unless key.size <= 64
      context = {
        h: IV.dup,
        t: 0,
        outlen: outlen,
      }
      context[:h][0] ^= 0x01010000 ^ (key.size << 8) ^ outlen;
      context
    end

    # It supports streaming updates, but I don't want that here
    def blake2b(outlen, key, input)
      key = key.b
      input = input.b
      context = init(outlen, key)
      if key.size > 0
        input = zeropad(key) + input
      end
      input.byteslices(128).each do |slice|
        context[:t] += slice.size
        slice = zeropad(slice)
        compress(context, slice, context[:t] == input.size)
      end
      # Finalize the hash now
      context[:h]
    end

    def hexdigest(input, key: "", outlen: 64)
      digest = blake2b(outlen, key, input)
      digest.pack("Q*").unpack("H*")[0]
    end
  end
end
