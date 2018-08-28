module KangarooDiscreteLogarithm
  class << self
    def log(g, gk, n, min, max, s=0)
      xtrap, xtrapd = nil, nil
      ytrap, ytrapd = nil, nil

      midpoint = min + (max-min)/2

      x = g.powmod(midpoint, n)
      xd = midpoint
      y = gk
      yd = 0

      i = 0

      gv = Hash.new{ |ht,v| ht[v] = g.powmod(v, n) }

      while true
        i += 1
        fx = f(x+s)
        fy = f(y+s)

        xd += fx
        yd += fy

        x = (x * gv[fx]) % n
        y = (y * gv[fy]) % n

        # binding.pry if g.powmod(xd, n) != x
        # binding.pry if gk * g.powmod(yd, n) % n != y

        # Power of two? Set a trap!
        if (i-1) & i == 0
          ytrap = y
          ytrapd = yd
          xtrap = x
          xtrapd = xd
        end

        if ytrap == x
          u = (xd - ytrapd)
          binding.pry if g.powmod(u, n) != gk
          return u, i
        end

        if xtrap == y
          u = (xtrapd - yd)
          binding.pry if g.powmod(u, n) != gk
          return u, i
        end
      end
    end

    # It's a total mystery how to pick this
    # Something up to sqrt(N) ???
    # Something about powers of two?
    # In theory a lot of fs work as long as they're pseudorandom,
    # but it has huge performance implications
    def f(u)
      1 << (u.hash % 12)
    end
  end
end
