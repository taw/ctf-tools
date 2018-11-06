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

    def aes(k, n)
      block = ("%32x" % n).from_hex
      encrypt_block(k, block).reverse.to_hex.to_i(16)
    end

    def mac(k, r, n, m)
      c = pad_and_split(m)
      mr = poly(r, c)
      aes_n = aes(k, n)
      (mr + aes_n) % (2**128)
    end

    private def encrypt_block(key, block)
      raise unless block.size == 16 and key.size == 16
      crypt = OpenSSL::Cipher.new("AES-128-ECB")
      crypt.encrypt
      crypt.key = key
      crypt.padding = 0
      crypt.update(block) + crypt.final
    end
  end
end
