class BinaryPoly
  attr_reader :value, :degree

  def initialize(value)
    raise unless value.is_a?(Integer) and value >= 0
    @value = value
    if @value == 0
      @degree = -1
    else
      @degree = @value.to_s(2).size - 1
    end
  end

  def zero?
    @value == 0
  end

  def one?
    @value == 1
  end

  def x?
    @value == 2
  end

  def hash
    @value.hash
  end

  def eql?(other)
    self == other
  end

  def to_s
    "BinaryPoly[%b]" % @value
  end

  def inspect
    to_s
  end

  def ==(other)
    other.instance_of?(BinaryPoly) and @value == other.value
  end

  def +(other)
    raise unless other.instance_of?(BinaryPoly)
    BinaryPoly.new(@value ^ other.value)
  end

  def *(other)
    raise unless other.instance_of?(BinaryPoly)
    result = 0
    a = @value
    b = other.value
    while b != 0
      if b.odd?
        result ^= a
      end
      b >>= 1
      a <<= 1
    end
    BinaryPoly.new(result)
  end

  # There's surely a better way to do this, considering how fast square is
  def **(k)
    raise unless k.is_a?(Integer)
    raise "There are no inverses for BinaryPoly" if k < 0
    return BinaryPoly.one if k == 0

    a = self
    result = BinaryPoly.one
    while k > 0
      if k.odd?
        result = (result * a)
      end
      a = a.square
      k >>= 1
    end
    result
  end

  def square
    result = 0
    a = @value
    i = 1
    j = 1
    while a != 0
      if a&i != 0
        a ^= i
        result ^= j
      end
      i <<= 1
      j <<= 2
    end
    BinaryPoly.new(result)
  end

  # Very unoptimized
  def gcd(other)
    raise unless other.instance_of?(BinaryPoly)
    return self if self == other
    return other.gcd(self) if other.degree > @degree
    return self if other.zero?
    q, r = self.divmod(other)
    other.gcd(r)
  end

  def divmod(other)
    raise unless other.instance_of?(BinaryPoly)
    raise ZeroDivisionError, "Can't divide by 0" if other.zero?
    div_degree = other.degree
    degree_difference = @degree - div_degree

    if degree_difference < 0
      return [BinaryPoly.zero, self]
    end

    result = 0
    rem = @value
    divisor = other.value

    degree_difference.downto(0) do |i|
      top_power = 1 << (div_degree + i)
      if (top_power & rem) != 0
        rem ^= divisor << i
        result ^= 1 << i
      end
    end

    [BinaryPoly.new(result), BinaryPoly.new(rem)]
  end

  def /(other)
    divmod(other)[0]
  end

  def %(other)
    divmod(other)[1]
  end

  # This could probably get a lot faster somehow
  def powmod(k, other)
    raise unless k.is_a?(Integer)
    raise "There are no inverses for BinaryPoly" if k < 0
    return BinaryPoly.one if k == 0
    raise unless other.instance_of?(BinaryPoly)

    a = self
    result = BinaryPoly.one
    while k > 0
      if k.odd?
        result = (result * a) % other
      end
      a = a.square % other
      k >>= 1
    end

    result
  end

  def irreducible_by_brute_force?
    return true if @degree <= 1
    return false if @value.even?
    # deg-7 can be deg-3 factor
    # deg-8 needs to have deg-4 factor
    max_degree = @degree / 2
    possible_divisors = (2...(2 << max_degree))
    !possible_divisors.any?{|x| (self % BinaryPoly.new(x)).zero? }
  end

  # Rabin's test of irreducibility
  # https://en.wikipedia.org/wiki/Factorization_of_polynomials_over_finite_fields#Rabin's_test_of_irreducibility
  # q == 2
  # n == degree
  # f == self
  def irreducible?
    return true if @degree <= 1
    return false if @value.even?

    x = BinaryPoly.x
    distinct_primes = @degree.prime_division.map(&:first)

    distinct_primes.each do |p|
      nj = @degree / p
      qnj = 2 ** nj
      h = (x.powmod(qnj, self) - x) % self
      g = self.gcd(h)
      return false unless g.one?
    end

    qn = 2 ** @degree
    g = (x.powmod(qn, self) - x) % self

    g.zero?
  end

  # Wonders of characteristic 2 fields where a == -a
  def -@
    self
  end

  def -(other)
    raise unless other.instance_of?(BinaryPoly)
    BinaryPoly.new(@value ^ other.value)
  end

  class << self
    def zero
      @zero ||= new(0)
    end

    def one
      @one ||= new(1)
    end

    def x
      @x ||= new(2)
    end

    def random(max_degree)
      new(rand(2 ** (max_degree+1)))
    end

    def [](value)
      new(value)
    end
  end
end
