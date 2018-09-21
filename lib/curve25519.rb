module Curve25519
  class << self
    def prime
      2**255 - 19
    end

    def curve
      MontgomeryCurve.new(prime, 486662, 1)
    end

    def base_point
      9
    end

    def base_point_order
      2**252 + 27742317777372353535851937790883648493
    end

    def random_secret
      v = rand(2**256)
      # mysecret[0] &= 248;
      # mysecret[31] &= 127;
      # mysecret[31] |= 64;
      v &= ~(7 << (31*8))
      v &= ~128
      v |= 64
      v
    end
  end
end
