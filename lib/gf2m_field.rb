class GF2mField
  attr_reader :poly, :degree

  def initialize(poly)
    raise "GF(2^m) requires irreducible polynomial" unless poly.is_a?(BinaryPoly)
    raise "Polynomial must be irreducible" unless poly.irreducible?
    @poly = poly
    @degree = poly.degree
  end

  def ==(other)
    other.is_a?(GF2mField) and @poly == other.poly
  end

  def eql?(other)
    self == other
  end

  def hash
    @poly.hash
  end

  def elements
    (0...2**@degree).map{|i| GF2m.new(i, self) }
  end
end
