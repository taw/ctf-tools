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

  def **(k)
    raise unless k.is_a?(Integer)
    raise "There are no inverses for BinaryPoly" if k < 0
    return BinaryPoly.one if k == 0

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
      j <<= k
    end
    BinaryPoly.new(result)
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

  def gcd(other)
    raise unless other.instance_of?(BinaryPoly)
    raise "TODO"
  end

  def divmod(other)
    raise unless other.instance_of?(BinaryPoly)
    raise "TODO"
  end

  def irreducible?
    raise "TODO"
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
  end
end
