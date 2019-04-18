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
    self.class.new(c0 - c2, c1)
  end

  def -(other)
    raise unless self.class == other.class
    self.class.new(self.a - other.a, self.b - other.b)
  end

  def ==(other)
    self.class == other.class and self.a == other.a and self.b == other.b
  end

  class << self
    # This is quite hacky, maybe I should just kill the whole thing
    def [](prime)
      @instances ||= {}
      @instances[p] ||= begin
        Class.new(GFp2) do
          define_method(:prime) { prime }
        end
      end
    end
  end
end
