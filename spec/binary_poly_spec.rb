describe BinaryPoly do
  let(:zero) { BinaryPoly.zero }
  let(:one) { BinaryPoly.one }
  let(:x) { BinaryPoly.x }
  let(:small_points) { 256.times.map{|i| BinaryPoly.new(i)} }

  describe ".zero" do
    it do
      expect(zero.value).to eq(0)
    end
  end

  describe ".one" do
    it do
      expect(one.value).to eq(1)
    end
  end

  describe ".x" do
    it do
      expect(x.value).to eq(2)
    end
  end

  describe "zero?" do
    it do
      expect(small_points.select(&:zero?)).to eq([zero])
    end
  end

  describe "one?" do
    it do
      expect(small_points.select(&:one?)).to eq([one])
    end
  end

  describe "x?" do
    it do
      expect(small_points.select(&:x?)).to eq([x])
    end
  end


  describe "-@" do
    it do
      small_points.each do |a|
        expect(-a).to eq(a)
      end
    end
  end

  describe "+" do
    it "adds coefficients modulo 2" do
      small_points.each do |a|
        small_points.each do |b|
          expect(a+b).to eq(BinaryPoly.new(a.value ^ b.value))
        end
      end
    end
  end

  describe "-" do
    it "is same as +" do
      small_points.each do |a|
        small_points.each do |b|
          expect(a+b).to eq(BinaryPoly.new(a.value ^ b.value))
        end
      end
    end
  end

  describe "to_s and inspect" do
    let(:a) { BinaryPoly.new(0x53) }
    it do
      expect(a.to_s).to eq("BinaryPoly[1010011]")
      expect(a.inspect).to eq("BinaryPoly[1010011]")
    end

    it "handles zero correctly" do
      expect(zero.to_s).to eq("BinaryPoly[0]")
      expect(zero.inspect).to eq("BinaryPoly[0]")
    end
  end

  describe "degree" do
    it do
      expect(BinaryPoly.new(2 ** 117 + 1).degree).to eq(117)
      expect(BinaryPoly.new(2 ** 117).degree).to eq(117)
      expect(BinaryPoly.new(2 ** 117 - 1).degree).to eq(116)
      expect(BinaryPoly.new(0xCA).degree).to eq(7)
      expect(BinaryPoly.new(0x99).degree).to eq(7)
      expect(BinaryPoly.new(0x53).degree).to eq(6)
      expect(BinaryPoly.new(0x5).degree).to eq(2)
      expect(BinaryPoly.new(0x4).degree).to eq(2)
      expect(BinaryPoly.new(0x3).degree).to eq(1)
      expect(BinaryPoly.new(0x2).degree).to eq(1)
      expect(BinaryPoly.new(0x1).degree).to eq(0)
      expect(BinaryPoly.new(0x0).degree).to eq(-1)
    end
  end

  describe "*" do
    it do
      expect(BinaryPoly.new(0x53) * BinaryPoly.new(0xCA)).to eq(
        x**13 + x**12 + x**11 + x**10 + x**9 + x**8 + x**6 + x**5 + x**4 + x**3 + x**2 + x
      )
    end
  end

  describe "square" do
    it do
      small_points.each do |a|
        expect(a.square).to eq(a*a)
      end
    end
  end

  describe "**" do
    it do
        small_points.each do |a|
        expect(a ** 2).to eq(a * a)
        expect(a ** 3).to eq(a * a * a)
        expect(a ** 5).to eq(a * a * a * a * a)
        expect(a ** 7).to eq(a * a * a * a * a * a * a)
        expect(a ** 10).to eq(a * a * a * a * a * a * a * a * a * a)
      end
    end
  end

  describe "divmod" do
    it "raises exception if dividing by 0" do
      small_points.each do |a|
        expect{ a.divmod(zero) }.to raise_error(ZeroDivisionError)
        expect{ a / zero }.to raise_error(ZeroDivisionError)
        expect{ a % zero }.to raise_error(ZeroDivisionError)
      end
    end

    it "divides and remainder is of lower degree than divisor" do
      small_points[0,16].each do |a|
        small_points[0,16].each do |b|
          next if b.zero?
          c, d = a.divmod(b)
          expect(a).to eq(b*c + d)
          expect(d.degree).to be < b.degree
          expect(c).to eq(a / b)
          expect(d).to eq(a % b)
        end
      end
    end
  end

  describe "powmod" do
    it do
      1000.times do
        a = BinaryPoly.random(20)
        f = BinaryPoly.random(20)
        k = rand(21)
        expect(a.powmod(k, f)).to eq((a**k) % f)
      end
    end
  end
end
