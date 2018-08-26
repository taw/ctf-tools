module Poly1305
  Prime = 2**130 - 5

  class << self
    def pad_and_split(message)
      message.byteslices(16).map do |m|
        ("1" + m.reverse.to_hex).to_i(16)
      end
    end

    def poly(r, c)
      mr = 0
      c.each do |ci|
        mr = ((mr + ci) * r) % Poly1305::Prime
      end
      mr
    end
  end
end
