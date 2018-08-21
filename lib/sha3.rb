# SHA3-256
module SHA3
  class << self
    RC = [
      0x0000000000000001,
      0x0000000000008082,
      0x800000000000808A,
      0x8000000080008000,
      0x000000000000808B,
      0x0000000080000001,
      0x8000000080008081,
      0x8000000000008009,
      0x000000000000008A,
      0x0000000000000088,
      0x0000000080008009,
      0x000000008000000A,
      0x000000008000808B,
      0x800000000000008B,
      0x8000000000008089,
      0x8000000000008003,
      0x8000000000008002,
      0x8000000000000080,
      0x000000000000800A,
      0x800000008000000A,
      0x8000000080008081,
      0x8000000000008080,
      0x0000000080000001,
      0x8000000080008008,
    ]

    private def rot(x, i)
      (x << i) & 0xffff_ffff_ffff_ffff | (x >> (64-i))
    end

    # For some example:
    # https://csrc.nist.gov/csrc/media/projects/cryptographic-standards-and-guidelines/documents/examples/sha3-256_msg0.pdf

    # state is [x+5*y]
    def round(state, rci)
      a = state.dup
      # θ step
      # C[x] = A[x,0] xor A[x,1] xor A[x,2] xor A[x,3] xor A[x,4], for x in 0…4
      c = [
        a[ 0] ^ a[ 5] ^ a[10] ^ a[15] ^ a[20],
        a[ 1] ^ a[ 6] ^ a[11] ^ a[16] ^ a[21],
        a[ 2] ^ a[ 7] ^ a[12] ^ a[17] ^ a[22],
        a[ 3] ^ a[ 8] ^ a[13] ^ a[18] ^ a[23],
        a[ 4] ^ a[ 9] ^ a[14] ^ a[19] ^ a[24],
      ]
      # D[x] = C[x-1] xor rot(C[x+1],1), for x in 0…4
      d = (0..4).map{|x|
        c[(x-1) % 5] ^ rot(c[(x+1) % 5], 1)
      }
      # A[x,y] = A[x,y] xor D[x], for (x,y) in (0…4,0…4)
      5.times do |x|
        5.times do |y|
          a[x+5*y] = a[x+5*y] ^ d[x]
        end
      end

      # ρ and π steps
      # B[y,2*x+3*y] = rot(A[x,y], r[x,y]), for (x,y) in (0…4,0…4)
      b = 25.times.map{ 0 }
      r = [
         0,  1, 62, 28, 27,
        36, 44,  6, 55, 20,
         3, 10, 43, 25, 39,
        41, 45, 15, 21,  8,
        18,  2, 61, 56, 14,
      ]
      5.times do |x|
        5.times do |y|
          b[y + 5*((2*x+3*y) % 5)] = rot(a[x+5*y], r[x+5*y])
        end
      end

      # χ step
      # A[x,y] = B[x,y] xor ((not B[x+1,y]) and B[x+2,y]),  for (x,y) in (0…4,0…4)
      5.times do |x|
        5.times do |y|
          b1 = b[((x+1) % 5) + 5*y]
          b2 = b[((x+2) % 5) + 5*y]
          a[x+5*y] = b[x+5*y] ^ ((~b1) & b2)
        end
      end

      # ι step
      a[0] ^= rci
      a
    end

    def permute(state)
      RC.each do |rci|
        state = round(state, rci)
      end
      state
    end

    def absorb_block(state, block)
      state = (0...25).map do |i|
        if i < 17
          state[i] ^ block[i]
        else
          state[i]
        end
      end
      permute(state)
    end

    def hexdigest(message)
      # Initialization
      s = initial_state

      # Absorbisg phase
      each_block(message) do |block|
        s = absorb_block(s, block)
      end

      # There's squeezing phase in more generic Keccak
      # but there's none in SHA3-256

      s[0,4].pack("Q<4").unpack("Q>4").map{|x| "%016x" % x }.join
    end

    private def initial_state
      25.times.map{ 0 }
    end

    private def each_block(message)
      block_size = 136
      message = message.b + "\x06"
      message += "\x00" * (-message.size % block_size)
      message[-1] = message[-1].xor("\x80")
      i = 0
      while i < message.size
        yield message[i*block_size, block_size].unpack("Q<*")
        i += block_size
      end
      nil
    end
  end
end
