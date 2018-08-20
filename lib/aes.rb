module AES
  SBOX = %W[
    63 7c 77 7b f2 6b 6f c5 30 01 67 2b fe d7 ab 76
    ca 82 c9 7d fa 59 47 f0 ad d4 a2 af 9c a4 72 c0
    b7 fd 93 26 36 3f f7 cc 34 a5 e5 f1 71 d8 31 15
    04 c7 23 c3 18 96 05 9a 07 12 80 e2 eb 27 b2 75
    09 83 2c 1a 1b 6e 5a a0 52 3b d6 b3 29 e3 2f 84
    53 d1 00 ed 20 fc b1 5b 6a cb be 39 4a 4c 58 cf
    d0 ef aa fb 43 4d 33 85 45 f9 02 7f 50 3c 9f a8
    51 a3 40 8f 92 9d 38 f5 bc b6 da 21 10 ff f3 d2
    cd 0c 13 ec 5f 97 44 17 c4 a7 7e 3d 64 5d 19 73
    60 81 4f dc 22 2a 90 88 46 ee b8 14 de 5e 0b db
    e0 32 3a 0a 49 06 24 5c c2 d3 ac 62 91 95 e4 79
    e7 c8 37 6d 8d d5 4e a9 6c 56 f4 ea 65 7a ae 08
    ba 78 25 2e 1c a6 b4 c6 e8 dd 74 1f 4b bd 8b 8a
    70 3e b5 66 48 03 f6 0e 61 35 57 b9 86 c1 1d 9e
    e1 f8 98 11 69 d9 8e 94 9b 1e 87 e9 ce 55 28 df
    8c a1 89 0d bf e6 42 68 41 99 2d 0f b0 54 bb 16
  ].map{ |x| x.to_i(16)}

  INV_SBOX = %W[
    52 09 6a d5 30 36 a5 38 bf 40 a3 9e 81 f3 d7 fb
    7c e3 39 82 9b 2f ff 87 34 8e 43 44 c4 de e9 cb
    54 7b 94 32 a6 c2 23 3d ee 4c 95 0b 42 fa c3 4e
    08 2e a1 66 28 d9 24 b2 76 5b a2 49 6d 8b d1 25
    72 f8 f6 64 86 68 98 16 d4 a4 5c cc 5d 65 b6 92
    6c 70 48 50 fd ed b9 da 5e 15 46 57 a7 8d 9d 84
    90 d8 ab 00 8c bc d3 0a f7 e4 58 05 b8 b3 45 06
    d0 2c 1e 8f ca 3f 0f 02 c1 af bd 03 01 13 8a 6b
    3a 91 11 41 4f 67 dc ea 97 f2 cf ce f0 b4 e6 73
    96 ac 74 22 e7 ad 35 85 e2 f9 37 e8 1c 75 df 6e
    47 f1 1a 71 1d 29 c5 89 6f b7 62 0e aa 18 be 1b
    fc 56 3e 4b c6 d2 79 20 9a db c0 fe 78 cd 5a f4
    1f dd a8 33 88 07 c7 31 b1 12 10 59 27 80 ec 5f
    60 51 7f a9 19 b5 4a 0d 2d e5 7a 9f 93 c9 9c ef
    a0 e0 3b 4d ae 2a f5 b0 c8 eb bb 3c 83 53 99 61
    17 2b 04 7e ba 77 d6 26 e1 69 14 63 55 21 0c 7d
  ].map{ |x| x.to_i(16)}

  class << self
    def add(a, b)
      a ^ b
    end

    def mul(a, b)
      p = 0
      while a != 0 and b != 0
        if b.odd?
          p ^= a
        end
        a <<= 1
        if a >= 256
          a ^= 0b1_0001_1011
        end
        b >>= 1
      end
      p
    end

    def safe_mul(a, b)
      p = 0
      9.times do
        p ^= -(b&1) & a
        mask = -((a >> 7) & 1)
        a = (a << 1) ^ (0b1_0001_1011 & mask)
        b >>= 1
      end
      p
    end

    def mul2(a)
      a <<= 1
      if a >= 256
        a ^= 0b1_0001_1011
      end
      a
    end

    def mul3(a)
      mul2(a) ^ a
    end

    def transpose4x4(state)
      state.each_slice(4).to_a.transpose.flatten
    end

    def shift_rows(state)
      raise unless state.size == 16
      [
        state[ 0], state[ 1], state[ 2], state[ 3],
        state[ 5], state[ 6], state[ 7], state[ 4],
        state[10], state[11], state[ 8], state[ 9],
        state[15], state[12], state[13], state[14],
      ]
    end

    def inv_shift_rows(state)
      raise unless state.size == 16
      [
        state[ 0], state[ 1], state[ 2], state[ 3],
        state[ 7], state[ 4], state[ 5], state[ 6],
        state[10], state[11], state[ 8], state[ 9],
        state[13], state[14], state[15], state[12],
      ]
    end

    def add_round_key(state, round_key)
      state.zip(round_key).map{ |a, b| a ^ b }
    end

    def inv_add_round_key(state, round_key)
      add_round_key(state, round_key)
    end

    def mix_column(column)
      raise unless column.size == 4
      a, b, c, d = column
      a2 = mul2(a)
      b2 = mul2(b)
      c2 = mul2(c)
      d2 = mul2(d)
      [
        a2 ^ b2 ^ b ^ c ^ d,
        a ^ b2 ^ c2 ^ c ^ d,
        a ^ b ^ c2 ^ d2 ^ d,
        a2 ^ a ^ b ^ c ^ d2,
      ]
    end

    def inv_mix_column(column)
      raise unless column.size == 4
      a, b, c, d = column
      [
        mul(a, 14) ^ mul(b, 11) ^ mul(c, 13) ^ mul(d,  9),
        mul(a,  9) ^ mul(b, 14) ^ mul(c, 11) ^ mul(d, 13),
        mul(a, 13) ^ mul(b,  9) ^ mul(c, 14) ^ mul(d, 11),
        mul(a, 11) ^ mul(b, 13) ^ mul(c,  9) ^ mul(d, 14),
      ]
    end

    def mix_columns(state)
      raise unless state.size == 16
      result = 16.times.map{ nil }
      (0..3).each do |i|
        column = (0..3).map{ |j| state[i + 4*j] }
        column = mix_column(column)
        (0..3).each do |j|
          result[i + 4*j] = column[j]
        end
      end
      result
    end

    def inv_mix_columns(state)
      raise unless state.size == 16
      result = 16.times.map{ nil }
      (0..3).each do |i|
        column = (0..3).map{ |j| state[i + 4*j] }
        column = inv_mix_column(column)
        (0..3).each do |j|
          result[i + 4*j] = column[j]
        end
      end
      result
    end

    def sub_bytes(state)
      state.map{ |u| SBOX[u] }
    end

    def inv_sub_bytes(state)
      state.map{ |u| INV_SBOX[u] }
    end
  end
end
