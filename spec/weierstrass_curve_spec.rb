describe WeierstrassCurve do
  describe "WeierstrassCurve(GF5, 1, 1)" do
    let(:group) { WeierstrassCurve.new(5, 1, 1) }
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

  describe "WeierstrassCurve(GF257, 1, 1)" do
    let(:group) { WeierstrassCurve.new(257, 1, 1) }
    let(:g) { [0, 1] }
    let(:g15) { 15.times.map{ g }.reduce{|a,b| group.add(a,b) } }

    it "points" do
      expect(group.points.size).to eq(249)
    end

    it "multiply" do
      expect(group.multiply(g, 15)).to eq(g15)
      expect(group.multiply(g, -15)).to eq(group.negate(g15))
    end
  end

  describe "#points" do
    let(:group) { WeierstrassCurve.new(65537, 1, 1) }

    it "points" do
      expect(group.points.size).to eq(65581)
    end
  end

  describe "log" do
    let(:prime) { 233970423115425145524320034830162017933 }
    let(:twist_order) { 2 * prime + 2 - 233970423115425145498902418297807005944 }
    let(:group) { MontgomeryCurve.new(prime, 534, 1).to_twist.associated_weierstrass_curve }
    let(:base_point) { group.multiply(group.random_point, twist_order / order) }
    let(:k) { rand(0...order) }
    let(:point) { group.multiply(base_point, k) }

    describe "#log_by_brute_force" do
      let(:order) { 1621 }
      it do
        expect(group.log_by_brute_force(base_point, point, 0, order-1)).to eq(k)
      end
    end

    describe "#log_by_bsgs" do
      let(:order) { 2323367 }
      it do
        expect(group.log_by_bsgs(base_point, point, 0, order-1)).to eq(k)
      end
    end
  end
end
