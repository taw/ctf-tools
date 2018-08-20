class String
  def to_i_binary
    unpack("C*").inject(0) do |a,b|
      a*256 + b
    end
  end

  def from_hex
    [self].pack("H*")
  end

  def to_hex
    self.unpack("H*")[0]
  end

  def xor(other)
    s1 = unpack("C*")
    s2 = other.unpack("C*")
    raise "Incompatible sizes" unless s1.size == s2.size
    s1.zip(s2).map{|u,v| u^v}.pack("C*")
  end
end
