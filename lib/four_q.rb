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
    raise unless other.is_a?(FourQ)
    ax = @x
    bx = other.x
    ay = @y
    by = other.y

    ax_bx = ax*bx
    ay_by = ay*by
    dxxyy = D * ax_bx * ay_by

    rx = (ax*by + bx*ay) / (Field.one + dxxyy)
    ry = (ay_by + ax_bx) / (Field.one - dxxyy)
    FourQ.new(rx, ry)
  end

  def double
    xy = @x*@y
    x2 = @x*@x
    y2 = @y*@y
    dx2y2 = D*x2*y2
    rx = (xy + xy) / (Field.one + dx2y2)
    ry = (y2 + x2) / (Field.one - dx2y2)
    FourQ.new(rx, ry)
  end

  def -@
    FourQ.new(-@x, @y)
  end

  def -(other)
    raise unless other.is_a?(FourQ)
    self + (-other)
  end

  def *(k)
    raise unless k.is_a?(Integer)
    return Zero if k == 0
    return (-self) * (-k) if k < 0

    result = Zero
    a = self
    while k > 0
      if k.odd?
        result += a
      end
      a = a.double
      k >>= 1
    end
    result
  end
end
