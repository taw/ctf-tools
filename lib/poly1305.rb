module Poly1305
  class << self
    def pad_and_split(message)
      message.byteslices(16).map do |m|
        ("1" + m.reverse.to_hex).to_i(16)
      end
    end
  end
end
