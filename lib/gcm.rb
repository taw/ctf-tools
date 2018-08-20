module GCM
  class << self
    # no reflection version
    # Such a weird hack
    def mul(a, b)
      result = 0
      mask = 2**128 + 2**127 + 2**126 + 2**121 + 1
      max = 2**128
      while a > 0 and b > 0
        if b[127] == 1
          result ^= a
        end
        b = (b << 1) & (max - 1)

        if a.odd?
          a ^= mask
        end
        a >>= 1
      end
      result
    end

    # this is stupid version
    def mul_reflect(a, b)
      a = reflect128(a)
      b = reflect128(b)
      result = 0

      mask = 2**128 + 128 + 4 + 2 + 1
      max = 2**128
      while a > 0 and b > 0
        if b.odd?
          result ^= a
        end
        b >>= 1

        a <<= 1
        if a >= max
          a ^= mask
        end
      end

      reflect128(result)
    end

    private def reflect128(n)
      ("%0128b" % n).reverse.to_i(2)
    end

    def encrypt(key, iv, aad, pt)
      zero_block = "\x00".b*16
      h = encrypt_block(key, zero_block).to_hex.to_i(16)
      ivh = encrypt_block(key, counter_block(iv, 1)).to_hex.to_i(16)

      tag = 0
      ct = "".b
      # AAD part
      # PT -> CT/tag part

      final_block = (aad.bytesize*8) * (2**64) | pt.bytesize*8
      tag = mul(tag^final_block, h)
      tag ^= ivh

      [aad, ct, tag]
    end

    private def counter_block(iv, i)
      iv + [i].pack("N")
    end

    private def encrypt_block(key, block)
      raise unless block.size == 16 and key.size == 16
      crypt = OpenSSL::Cipher.new("AES-128-ECB")
      crypt.encrypt
      crypt.key = key
      crypt.padding = 0
      crypt.update(block) + crypt.final
    end
  end
end