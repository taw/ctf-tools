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

    def reflect128(n)
      ("%0128b" % n).reverse.to_i(2)
    end
  end
end
