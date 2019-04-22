class B233
  Poly = BinaryPoly.x**233 + BinaryPoly.x**74 + BinaryPoly.one
  Field = GF2mField.new(Poly)
  A = 1
  B = GF2m.new(0x00000066_647EDE6C_332C7F8C_0923BB58_213B333B_20E9CE42_81FE115F_7D8F90AD, Field)
  N = 0x00000100_00000000_00000000_00000000_0013E974_E72F8A69_22031D26_03CFE0D7
  H = 2

  attr_reader :x, :y
  def initialize(x, y)
    @x = ensure_field(x)
    @y = ensure_field(y)
  end

  def valid?
    x2 = x.square
    y2 = y.square
    y2 + x*y == x2*x + x2 + B
  end

  def +(other)
    raise
  end

  def -(other)
    raise
  end

  def *(other)
    raise
  end

  private

  def ensure_field(num)
    num = BinaryPoly.new(num) if num.is_a?(Integer)
    num = GF2m.new(num, Field) if num.is_a?(BinaryPoly)
    raise unless num.is_a?(GF2m) and num.field == Field
    num
  end
end
