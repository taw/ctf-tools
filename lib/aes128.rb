module AES128
  class << self
    def expand_key(key)
      raise unless key.size == 16
      output = key.each_slice(4).to_a

      rcon = 1
      10.times do
        w = output[-1]
        x = [w[1], w[2], w[3], w[0]]
        y = [ AES::SBOX[x[0]], AES::SBOX[x[1]], AES::SBOX[x[2]], AES::SBOX[x[3]] ]
        z = [y[0] ^ rcon, y[1], y[2], y[3]]
        output << xormap(output[-4], z)
        output << xormap(output[-4], output[-1])
        output << xormap(output[-4], output[-1])
        output << xormap(output[-4], output[-1])
        rcon = AES.mul2(rcon)
      end
      output.flatten
    end

    private def xormap(ary, other)
      ary.zip(other).map{ |u,v| u^v }
    end

    # numbers arrays in / numbers array out
    def encrypt(key, state)
      raise unless key.size == 16
      raise unless state.size == 16

      state = AES.transpose4x4(state)

      key = expand_key(key)

      round_key = key[0, 16]
      round_key = AES.transpose4x4(round_key)
      state = AES.add_round_key(state, round_key)

      (1..9).each do |i|
        round_key = key[16*i, 16]
        round_key = AES.transpose4x4(round_key)
        state = AES.sub_bytes(state)
        state = AES.shift_rows(state)
        state = AES.mix_columns(state)
        state = AES.add_round_key(state, round_key)
      end

      # Last one without add_round_key
      round_key = key[16*10, 16]
      round_key = AES.transpose4x4(round_key)
      state = AES.sub_bytes(state)
      state = AES.shift_rows(state)
      state = AES.add_round_key(state, round_key)

      AES.transpose4x4(state)
    end

    def decrypt(key, state)
      raise unless key.size == 16
      raise unless state.size == 16

      state = AES.transpose4x4(state)

      key = expand_key(key)

      # Last one without add_round_key
      round_key = key[16*10, 16]
      round_key = AES.transpose4x4(round_key)
      state = AES.inv_add_round_key(state, round_key)
      state = AES.inv_shift_rows(state)
      state = AES.inv_sub_bytes(state)

      [*1..9].reverse.each do |i|
        round_key = key[16*i, 16]
        round_key = AES.transpose4x4(round_key)
        state = AES.inv_add_round_key(state, round_key)
        state = AES.inv_mix_columns(state)
        state = AES.inv_shift_rows(state)
        state = AES.inv_sub_bytes(state)
      end

      round_key = key[0, 16]
      round_key = AES.transpose4x4(round_key)
      state = AES.inv_add_round_key(state, round_key)

      AES.transpose4x4(state)
    end

    private def print_state(msg, state)
      puts msg + state.map{|u| "%02x" % u}.each_slice(4).map{|u| u.join(" ") }.join(" | ")
    end
  end
end
