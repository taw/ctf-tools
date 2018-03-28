class String
  def to_i_binary
    unpack("C*").inject(0) do |a,b|
      a*256 + b
    end
  end
end
