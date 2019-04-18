class BinaryPoly
  attr_reader :value

  def initialize(value)
    raise unless value.is_a?(Integer) and value >= 0
    @value = value
  end

  def one?
    @value == 1
  end

  def zero?
    @value == 0
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
    raise "TODO"
  end

  def **(k)
    raise unless k.is_a?(Integer)
    raise "TODO"
  end

  def square
    warn "TODO: There are much faster ways"
    self * self
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

  def degree
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
      new(0)
    end

    def one
      new(1)
    end

    def x
      new(2)
    end
  end
end
