class B233
  Poly = BinaryPoly.x**233 + BinaryPoly.x**74 + BinaryPoly.one
  Field = GF2mField.new(Poly)
  A = GF2m.new(1, Field)
  B = GF2m.new(0x00000066_647EDE6C_332C7F8C_0923BB58_213B333B_20E9CE42_81FE115F_7D8F90AD, Field)
  N = 0x00000100_00000000_00000000_00000000_0013E974_E72F8A69_22031D26_03CFE0D7
  H = 2

  attr_reader :x, :y
  def initialize(x, y)
    if x.nil? and y.nil?
      # Point at infinity - special representation
      @x = nil
      @y = nil
    else
      @x = ensure_field(x)
      @y = ensure_field(y)
    end
  end

  def zero?
    @x.nil? and @y.nil?
  end

  def valid?
    return true if zero?
    x2 = x.square
    y2 = y.square
    y2 + x*y == x2*x + x2 + B
  end

  # https://hyperelliptic.org/EFD/g12o/auto-shortw-affine.html
  def +(other)
    raise unless other.is_a?(B233)
    return self if other.zero?
    return other if zero?
    return double if self == other
    x1 = @x
    x2 = other.x
    y1 = @y
    y2 = other.y
    # x1 == x2 is either same or negated
    return ZERO if x1 == x2
    lam = (y1+y2) / (x1+x2)
    x3 = lam.square + lam + x1 + x2 + A
    y3 = lam * (x1+x3) + x3 + y1
    B233.new(x3, y3)
  end

  def double
    return self if zero?
    lam = @x + @y/@x
    x3 = lam.square + lam + A
    y3 = lam * (@x + x3) + x3 + @y
    B233.new(x3, y3)
  end

  def -@
    return self if zero?
    B233.new(@x, @x+@y)
  end

  def -(other)
    raise unless other.is_a?(B233)
    self + (-other)
  end

  def *(k)
    raise unless k.is_a?(Integer)
    return ZERO if k == 0
    return (-self) * (-k) if k < 0
    result = ZERO
    a = self
    while k > 0
      result += a if k.odd?
      a = a.double
      k >>= 1
    end
    result
  end

  def ==(other)
    other.is_a?(B233) and @x == other.x and @y == other.y
  end

  def hash
    [@x, @y].hash
  end

  def eql?(other)
    self == other
  end

  ZERO = new(nil, nil)

  private

  def ensure_field(num)
    num = BinaryPoly.new(num) if num.is_a?(Integer)
    num = GF2m.new(num, Field) if num.is_a?(BinaryPoly)
    raise unless num.is_a?(GF2m) and num.field == Field
    num
  end
end
