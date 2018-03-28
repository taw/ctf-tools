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
end
