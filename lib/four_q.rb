# https://eprint.iacr.org/2015/565.pdf
class FourQ
  Prime = 2**127 - 1
  Field = GFp2[Prime]
  A = Field.new(-1)
  D = Field.new(4205857648805777768770, 125317048443780598345676279555970305165)

  attr_reader :x
  attr_reader :y
  def initialize(x, y)
    raise unless x.class == Field
    raise unless y.class == Field
    @x = x
    @y = y
  end

  Zero = FourQ.new(Field.zero, Field.one)

  def ==(other)
    other.is_a?(FourQ) and @x == other.x and @y == other.y
  end

  def hash
    [@x, @y].hash
  end

  def eql?(other)
    self == other
  end


  def valid?
    x2 = x.square
    y2 = y.square
    -x2 + y2 == Field.one + D * x2 * y2
  end

  def +(other)
    raise
  end

  def -@
    raise
  end

  def -(other)
    raise
  end

  def *
    raise
  end
end
