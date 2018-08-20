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
end
