# y^2 = x^3 + ax + b
class WeierstrassCurve
  attr_reader :p, :a, :b

  def initialize(p, a, b)
    @p = p
    @a = a % p
    @b = b % p

    if (4 * (@a ** 3) + 27 * (@b ** 2)) % @p == 0
      raise "Incorrect curve"
    end
  end

  def valid?(point)
    return true if point == :infinity
    x, y = point
    (-(y ** 2) + (x ** 3) + a * x + b) % p == 0
  end

  def negate(point)
    return point if point == :infinity
    x, y = point
    [x, -y % p]
  end

  def add(p1, p2)
    return p2 if p1 == :infinity
    return p1 if p2 == :infinity
    return :infinity if p1 == negate(p2)

    x1, y1 = p1
    x2, y2 = p2

    if p1 == p2
      m = ((3 * x1 * x1 + a) * (2 * y1).invmod(@p)) % @p
    else
      m = ((y2 - y1) * (x2 - x1).invmod(@p)) % @p
    end

    xr = (m * m - x1 - x2) % @p
    yr = (m * (x1 - xr) - y1) % @p
    [xr, yr]
  end

  def multiply(point, n)
    result = :infinity
    if n < 0
      n = -n
      point = negate(point)
    end

    while n > 0
      if n.odd?
        result = add(result, point)
      end
      n >>= 1
      point = add(point, point)
    end

    result
  end

  # infinity is technically a point too, but don't bother
  def random_point
    while true
      x = rand(0...@p)
      yy = (x ** 3 + @a * x + @b) % @p
      y = yy.sqrtmod(@p)
      if y
        if rand(2) == 0
          return [x, y]
        else
          return [x, @p - y]
        end
      end
    end
  end

  def random_point_of_order(group_order, requested_point_order)
    raise "Invalid request" if group_order % requested_point_order != 0
    m = group_order / requested_point_order
    while true
      point = multiply(random_point, m)
      return point unless point == :infinity
    end
  end

  # Various algorithms for counting points:
  # O(p^2) - brute force
  def points_n2
    result = [:infinity]
    (0...@p).each do |x|
      (0...@p).each do |y|
        point = [x, y]
        result << point if valid?(point)
      end
    end
    result
  end

  # O(p^1) - very slow
  def points
    result = [:infinity]
    (0...@p).each do |x|
      yy = ((x ** 3) + a * x + b) % @p
      y = yy.sqrtmod(@p)
      next unless y
      point = [x, y]
      result << point if valid?(point)
      # p-y === y
      # p === 2y
      # So if p is even or y is zero
      if y != 0
        point2 = [x, @p - y]
        result << point2 if valid?(point2)
      end
    end
    result
  end

  # O(n^1)
  def count_points_brute_force
    # Point at infinity
    count = 1
    (0...@p).each do |x|
      yy = ((x ** 3) + a * x + b) % @p
      y = yy.sqrtmod(@p)
      next unless y
      if y == 0
        count += 1
      else
        count += 2
      end
    end
    count
  end

  #https://en.wikipedia.org/wiki/Hasse%27s_theorem_on_elliptic_curves
  def hasse_bounds
    # integer root would be more accurate and save us a bit of range
    ps = Math.sqrt(@p).ceil
    (@p + 1 - 2 * ps)..(@p + 1 + 2 * ps)
  end

  # These can be seriously optimized further
  # replacing mul with add etc.

  # O(n^0.5)
  def count_points_hasse
    100.times do
      pt = random_point
      # There will be at least one
      # If we find multiple, just restart
      ks = hasse_bounds.select { |k| multiply(pt, k + 1) == :infinity }
      raise "Math failed us" if ks.empty?
      return ks[0] if ks.size == 1
    end
    raise "We failed in 100 retries, this statistically shouldn't happen (for a reasonable curve)"
  end

  # O(n^0.25)
  def count_points_gsbs
    bounds = hasse_bounds
    range_start = bounds.first
    range_end = bounds.last
    step_size = (@p ** 0.25).ceil
    100.times do
      big_steps = {}
      pt = random_point
      i = range_start
      pt_i = multiply(pt, range_start)
      pt_step = multiply(pt, step_size)
      while i < range_end
        # Actually should just retry with another radom point
        raise "MAJOR FAIL" if big_steps[pt_i]
        big_steps[pt_i] = i
        i += step_size
        pt_i = add(pt_i, pt_step)
      end

      minus_pt = negate(pt)
      pt_j = :infinity
      step_size.times do |j|
        if big_steps[pt_j]
          i = big_steps[pt_j]
          # multiply(pt, -j) == multiply(pt, i)
          raise unless multiply(pt, i + j) == :infinity
          return i + j - 1
        end
        pt_j = add(pt_j, minus_pt)
      end

      # Keep trying!
      # Actually what do we do if we have multiple hits ???
    end
    raise "We failed in 100 retries, this statistically shouldn't happen (for a reasonable curve)"
  end

  def ==(other)
    other.is_a?(WeierstrassCurve) and self.p == other.p and self.a == other.a and self.b == other.b
  end

  def log_by_brute_force(base_point, target, min, max)
    gi = multiply(base_point, min)
    (min..max).each do |i|
      return i if gi == target
      gi = add(gi, base_point)
    end
    nil
  end

  def log_by_bsgs(base_point, target, min, max)
    range_size = max - min + 1
    s = Math.sqrt(range_size).round
    z = (range_size + s - 1) / s
    raise unless s * z >= range_size
    ht = {}
    gi = multiply(base_point, min)
    s.times do |i|
      ht[gi] = min + i
      gi = add(gi, base_point)
    end
    gms = multiply(negate(base_point), s)
    gj = target
    z.times do |j|
      if ht[gj]
        return ht[gj] + s * j
      end
      gj = add(gj, gms)
    end
    nil
  end
end
