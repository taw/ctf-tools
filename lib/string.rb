class String
  def to_i_binary
    unpack("C*").reduce(0) do |a,b|
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

  def byteslices(slice_size)
    result = []
    msg = b
    ofs = 0
    while ofs < msg.size
      result << msg[ofs, slice_size]
      ofs += slice_size
    end
    result
  end
end
