class GFp2
  attr_reader :a, :b

  def initialize(a=0, b=0)
    @a = a % prime
    @b = b % prime
  end

  def p
    prime
  end

  def to_s
    "GF[#{p}^2][#{a},#{b}]"
  end

  def inspect
    to_s
  end

  def -@
    self.class.new(-a, -b)
  end

  def +(other)
    raise unless self.class == other.class
    self.class.new(self.a + other.a, self.b + other.b)
  end

  def *(other)
    raise unless self.class == other.class
    c0 = self.a * other.a
    c1 = self.a * other.b + self.b * other.a
    c2 = self.b * other.b
    # Irreductible polynomial is (unsurprisingly): x^2 + 1
    # This only works for p % 4 == 3
    self.class.new(c0 - c2, c1)
  end

  # This is just an optimization
  # This would work too:
  #   self * self
  def square
    c0 = @a * @a
    c1 = 2 * @a * @b
    c2 = @b * @b
    self.class.new(c0 - c2, c1)
  end

  def -(other)
    raise unless self.class == other.class
    self.class.new(self.a - other.a, self.b - other.b)
  end

  def ==(other)
    self.class == other.class and self.a == other.a and self.b == other.b
  end

  def eql?(other)
    self == other
  end

  def zero?
    @a == 0 and @b == 0
  end

  def one?
    @a == 1 and @b == 0
  end

  def hash
    [@a, @b].hash
  end

  # There should be a faster way
  def inverse
    raise ZeroDivisionError, "Can't invert 0" if zero?
    self ** (prime**2 - 2)
  end

  def **(k)
    raise unless k.is_a?(Integer)
    # Special handling for zero, not obviously right or wrong
    if zero?
      return self.class.zero if k > 0
      raise ZeroDivisionError, "Can't invert 0" if k < 0
      return self.class.one
    end

    # It is a field!
    k %= p**2 - 1
    # Otherwise we'd need to do this, basically doubling the cost:
    # return inverse ** (-k) if k < 0

    result = self.class.one
    power = self
    while k > 0
      if k.odd?
        result *= power
      end
      power = power.square
      k >>= 1
    end
    result
  end

  class << self
    def points
      (0...@prime).flat_map do |a|
        (0...@prime).flat_map do |b|
          new(a, b)
        end
      end
    end

    def zero
      @zero ||= new(0, 0)
    end

    def one
      @one ||= new(1, 0)
    end

    # This is quite hacky, maybe I should just kill the whole thing
    def [](prime)
      # We could handle other cases by choosing another polynomial
      raise "i^2 == -1 would not be irreducible unless prime%4 == 3" unless prime % 4 == 3
      @instances ||= {}
      @instances[p] ||= begin
        Class.new(GFp2) do
          @prime = prime
          define_method(:prime) { prime }
        end
      end
    end
  end
end
