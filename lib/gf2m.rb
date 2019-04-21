class GF2m
  attr_reader :value, :field

  def initialize(value, field)
    value = BinaryPoly.new(value) if value.is_a?(Integer)
    raise "Degree too high" if value.degree >= field.degree
    @value = value
    @field = field
  end

  def zero?
    @value.zero?
  end

  def one?
    @value.one?
  end

  def x?
    @value.x?
  end

  def -@
    self
  end

  def +(other)
    raise unless same_field?(other)
    create_new @value + other.value
  end

  def -(other)
    self + other
  end

  def *(other)
    raise unless same_field?(other)
    create_new (@value * other.value) % @field.poly
  end

  def /(other)
    raise unless same_field?(other)
    raise ZeroDivisionError, "Can't divide by 0" if other.zero?
    self * other.inverse
  end

  def to_s
    # Don't print polynomial modulo
    "GF(2^%d)[%b]" % [@field.degree, @value.value]
  end

  def inspect
    to_s
  end

  def ==(other)
    same_field?(other) and @value == other.value
  end

  def hash
    [@value, @field].hash
  end

  def eql?(other)
    self == other
  end

  def **(k)
    raise unless k.is_a?(Integer)
    if zero?
      return create_new(BinaryPoly.zero) if k == 0
      raise ZeroDivisionError, "Can't invert 0" if k < 0
      return create_new(BinaryPoly.one)
    end
    return inverse ** -k if k < 0
    create_new @value.powmod(k, @field.poly)
  end

  def square
    create_new(@value.square % @field.poly)
  end

  def inverse
    raise ZeroDivisionError, "Can't divide by 0" if zero?
    create_new @value.powmod((2 ** @field.degree) -2, @field.poly)
  end

  private

  def same_field?(other)
    other.is_a?(GF2m) and @field == other.field
  end

  def create_new(value)
    GF2m.new(value, @field)
  end
end
