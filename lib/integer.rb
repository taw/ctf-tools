class Integer
  def to_s_binary
    i = self
    out = []
    while i > 0
      c = i & 0xff
      i >>= 8
      out << c
    end
    out.pack("C*").reverse
  end

  def powmod(exponent, modulus)
    return 0 if modulus == 1
    result = 1 
    base = self % modulus
    while exponent > 0 
      result = result*base%modulus if exponent%2 == 1
      exponent = exponent >> 1
      base = base*base%modulus
    end 
    result
  end

  def extended_gcd(b)
    a = self
    last_remainder, remainder = a.abs, b.abs
    x, last_x, y, last_y = 0, 1, 1, 0
    while remainder != 0
      last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
      x, last_x = last_x - quotient*x, x
      y, last_y = last_y - quotient*y, y
    end

    return last_remainder, last_x * (a < 0 ? -1 : 1)
  end

  def invmod(et)
    g, x = extended_gcd(et)
    raise "The maths are broken!" unless g == 1
    x % et
  end

  def root(n)
    raise "Can't integer root negative number" if n < 0
    (0..self).bsearch{|i| self - i**n }
  end

  def root_ceil(n)
    raise "Can't integer root negative number" if n < 0
    (0..self).bsearch{|i| i**n >= self }
  end
end
