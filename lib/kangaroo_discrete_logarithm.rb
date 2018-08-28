module KangarooDiscreteLogarithm
  class << self
    def log(g, gk, n, min, max)
      trap = min
      trapd = 0

      x = g.powmod(min, n)
      xd = min
      y = gk
      yd = 0

      i = 0

      range = (max-min+1)
      gnrange = g.powmod(-range, n)

      while true
        i += 1
        fx = f(x)
        fy = f(y)

        xd += fx
        yd += fy

        x = (x * g.powmod(fx, n)) % n
        y = (y * g.powmod(fy, n)) % n

        binding.pry if g.powmod(xd, n) != x
        binding.pry if gk * g.powmod(yd, n) % n != y


        # Power of two? Set a trap!
        if (i-1) & i == 0
          trap = y
          trapd = yd
          if gk * g.powmod(trapd, n) % n != trap
            binding.pry
          end
        end

        if trap == x
          u = (xd - trapd)
          binding.pry if g.powmod(u, n) != gk
          return u, i
        end

        # Our search failed
        # We could pick another f and retry.
        # Or we could try this
        if xd > max
          puts "Shift back!"
          xd -= range
          yd -= range
          x = (x * gnrange) % n
          y = (y * gnrange) % n
        end
      end
    end

    # It's a total mystery how to pick this
    # Something up to sqrt(N) ???
    # Something about powers of two?
    # In theory a lot of fs work as long as they're pseudorandom,
    # but it has huge performance implications
    def f(u)
      1 << (u.hash % 10)
    end
  end
end
