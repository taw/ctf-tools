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
end
