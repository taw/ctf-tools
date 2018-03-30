module RSA
  class <<self
    def encrypt(pt, e:, n:)
      pt.powmod(e, n)
    end

    def decrypt(ct, d:, n:)
      ct.powmod(d, n)
    end

    def derive_d(e:, p:, q:)
      e.invmod((p-1)*(q-1))
    end

    def chinese_remainder(remainders, mods)
      max = mods.inject(:*)
      series = remainders.zip(mods).map{ |r,m| (r * max * (max/m).invmod(m) / m) }
      series.inject(:+) % max
    end
  end
end
