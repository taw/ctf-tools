describe ECC do
  describe "ECC(GF5, 1, 1)" do
    let(:group) { ECC.new(5, 1, 1) }
    let(:points) { group.points }

    it do
      expect(points.size).to eq(9)
    end

    it "add" do
      points.each do |p1|
        points.each do |p2|
          p3 = group.add(p1, p2)
          expect(group.valid?(p3)).to eq true
        end
      end
    end

  end

  describe "ECC(GF257, 1, 1)" do
    let(:group) { ECC.new(257, 1, 1) }
    let(:g) { [0, 1] }
    let(:g15) { 15.times.map{ g }.reduce{|a,b| group.add(a,b) } }

    it "multiply" do
      expect(group.multiply(g, 15)).to eq(g15)
      expect(group.multiply(g, -15)).to eq(group.negate(g15))
    end
  end
end
