# This is a fairly slow algorithm, but it uses zero memory
module RhoFactorization
  class << self
    def factor(n)
      a = 2
      b = 2
      i = 0
      while true
        a = step(a, n)
        b = step(step(b, n), n)
        u = n.gcd((b-a) % n)
        i += 1
        if u != 1
          return u, i
        end
      end
    end

    def step(x, n)
      (x*x + 1) % n
    end
  end
end
