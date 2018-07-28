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

    def factor_modulus(e:, d:, n:)
      t = (e * d - 1)
      s = 0

      while true
        quotient, remainder = t.divmod(2)
        break if remainder != 0
        s += 1
        t = quotient
      end

      found = false

      until found
        i = 1
        a = rand(2..(n-1))

        while i <= s and not found
          c1 = a.powmod(2.powmod(i-1, n) * t, n)
          c2 = a.powmod(2.powmod(i, n) * t, n)
          found = (c1 != 1 and c1 != (-1 % n) and c2 == 1)
          i += 1
        end
      end

      p = (c1-1).gcd(n)
      q = n / p

      [p, q].sort
    end
  end
end
