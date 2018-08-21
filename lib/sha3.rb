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

    # state is [x+5*y]
    def round(state, rci)
      # # θ step
      # C[x] = A[x,0] xor A[x,1] xor A[x,2] xor A[x,3] xor A[x,4],   for x in 0…4
      # D[x] = C[x-1] xor rot(C[x+1],1),                             for x in 0…4
      # A[x,y] = A[x,y] xor D[x],                           for (x,y) in (0…4,0…4)

      # # ρ and π steps
      # B[y,2*x+3*y] = rot(A[x,y], r[x,y]),                 for (x,y) in (0…4,0…4)

      # # χ step
      # A[x,y] = B[x,y] xor ((not B[x+1,y]) and B[x+2,y]),  for (x,y) in (0…4,0…4)

      # # ι step
      # A[0,0] = A[0,0] xor RC

      # return A
      state
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

      # Squeezing phase

      # Z = empty string
      # while output is requested
      #   Z = Z || S[x,y],                        for (x,y) such that x+5*y < r/w
      #   S = Keccak-f[r+c](S)

      # return Z

      ""
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
