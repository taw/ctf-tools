describe MontgomeryCurve do
  let(:prime) { 233970423115425145524320034830162017933 }
  # v^2 = u^3 + 534*u^2 + u
  let(:montgomery_curve) { MontgomeryCurve.new(prime, 534, 1) }
  let(:weierstrass_curve) { WeierstrassCurve.new(prime, -95051, 11279326) }
  let(:base_point) { u }
  let(:base_point_order) { 29246302889428143187362802287225875743 }
  let(:order) { 233970423115425145498902418297807005944 }
  let(:u) { 4 }
  let(:v) { 85518893674295321206118380980485522083 }
  let(:x) { u + 178 }
  let(:y) { v }
  let(:g) { [x,y] }

  let(:twist_order) { 2 * prime + 2 - order }
  let(:twist_factors) { [ 2, 2, 11, 107, 197, 1621, 105143, 405373, 2323367, 1571528514013 ] }

  it "has correct order" do
    expect( montgomery_curve.ladder(u, order) ).to eq(0)
    expect( montgomery_curve.ladder(u, order+1) ).to eq(u)

    # Hasse's theorem
    expect((order - (prime+1)).abs <= 2 * (prime**0.5)).to be true
  end

  describe "#diff_add" do
    let(:index_a) { rand(100..1000) }
    let(:index_b) { rand(1001..2000) }
    let(:a) { montgomery_curve.ladder(base_point, index_a) }
    let(:b) { montgomery_curve.ladder(base_point, index_b) }
    let(:b_minus_a) { montgomery_curve.ladder(base_point, index_b - index_a) }
    let(:c) { montgomery_curve.diff_add(a, b, b_minus_a) }
    let(:expected_c) { montgomery_curve.ladder(base_point, index_b + index_a) }

    describe "can differencially add arbitrary points on the curve" do
      it do
        expect(c).to eq(expected_c)
      end
    end

    describe "it also works with doubling" do
      let(:index_b) { index_a }
      it do
        expect(c).to eq(expected_c)
      end
    end
  end

  it "has correct twist_order" do
    expect(twist_order + order).to eq(2 * prime + 2)
    expect(twist_factors.reduce{|a,b| a*b}).to eq(twist_order)

    expect( montgomery_curve.ladder(6, twist_order) ).to eq(0)
    expect( montgomery_curve.ladder(6, twist_order+1) ).to eq(6)
  end

  describe "#to_twist" do
    let(:twist_curve) { montgomery_curve.to_twist }
    let(:double_twist_curve) { twist_curve.to_twist }
    let(:twist_weierstrass_curve) { twist_curve.to_twist }

    it do
      expect(double_twist_curve).to eq(montgomery_curve)
      expect(twist_weierstrass_curve).to_not be_nil
    end
  end

  # It doesn't work on curve, but it works if we convert it to a different curve
  describe "#add_by_weierstass" do
    let(:index_a) { rand(100..2000) }
    let(:index_b) { rand(100..2000) }
    let(:a) { montgomery_curve.ladder(base_point, index_a) }
    let(:b) { montgomery_curve.ladder(base_point, index_b) }
    let(:c) { montgomery_curve.add_by_weierstass(a, b) }
    let(:a_plus_b) { montgomery_curve.ladder(base_point, index_b + index_a) }
    let(:a_minus_b) { montgomery_curve.ladder(base_point, (index_b - index_a).abs) }

    it do
      expect(c).to match_array([a_plus_b, a_minus_b])
    end
  end

  it "maps point correctly between two curve formats" do
    [0, 1, 2, 1000, 123456, order-2, order-1, order].each do |k|
      gkm = montgomery_curve.ladder(u, k)
      gkw = weierstrass_curve.multiply(g, k)
      if gkw == :infinity
        expect(gkm).to eq(0)
      else
        expect(gkm).to eq(gkw[0]-178)
        # v or -v
        expect(montgomery_curve.calculate_v(gkm)).to include(gkw[1])
      end
    end
  end

  it "can still be attacked by invalid numbers" do
    evil_u = 76600469441198017145391791613091732004
    expect(montgomery_curve.ladder(evil_u, 11)).to eq(0)
    expect(montgomery_curve.calculate_v(evil_u)).to eq(nil)
  end

  it "associated_weierstrass_curve" do
    expect(montgomery_curve.associated_weierstrass_curve).to eq(weierstrass_curve)
  end

  describe "from and to weierstrass form" do
    let(:w) { m.associated_weierstrass_curve }

    describe "b=1" do
      let(:m) { montgomery_curve }

      it do
        10.times do
          xy  = w.random_point
          xy2 = w.multiply(xy, 2)
          expect(w.valid?(xy)).to eq true
          uv = m.from_weierstrass(xy)
          u2 = m.multiply(uv[0], 2)
          expect(m.valid?(*uv)).to eq true
          expect(m.to_weierstrass(uv)).to eq(xy)
          expect(m.to_weierstrass_all(u2)).to include(xy2)
        end
      end
    end

    describe "b!=1" do
      let(:m) { montgomery_curve.to_twist }

      it do
        10.times do
          xy  = w.random_point
          xy2 = w.multiply(xy, 2)
          expect(w.valid?(xy)).to eq true
          uv = m.from_weierstrass(xy)
          u2 = m.multiply(uv[0], 2)
          expect(m.valid?(*uv)).to eq true
          expect(m.to_weierstrass(uv)).to eq(xy)
          expect(m.to_weierstrass_all(u2)).to include(xy2)
        end
      end
    end
  end

  it "random_point" do
    10.times do
      point = montgomery_curve.random_point
      expect(montgomery_curve.valid?(point)).to eq true
    end
  end

  it "random_twist_point" do
    10.times do
      point = montgomery_curve.random_twist_point
      expect(point).to match(1...prime)
      expect(montgomery_curve.valid?(point)).to eq false
    end
  end

  it "random_twist_point" do
    twist_factors.uniq.each do |q|
      10.times do
        q = twist_order
        point = montgomery_curve.random_twist_point_of_order(twist_order, q)
        expect(point).to match(1...prime)
        expect(montgomery_curve.valid?(point)).to eq false
        expect(montgomery_curve.ladder(point, q)).to eq(0)
      end
    end
  end

  describe "#log_by_bsgs" do
    let(:twist_curve) { montgomery_curve.to_twist }
    let(:point_order) { 2323367 }
    let(:base_point) { twist_curve.multiply(twist_curve.random_point, twist_order / point_order) }
    let(:k) { rand(0...point_order) }
    let(:point) { twist_curve.multiply(base_point, k) }

    it do
      expect(twist_curve.log_by_bsgs(base_point, point, point_order)).to match_array([k, point_order-k])
    end

    describe "performance test" do
      let(:point_order) { 1571528514013 }

      it do
        expect(twist_curve.log_by_bsgs(base_point, point, point_order)).to match_array([k, point_order-k])
      end
    end
  end
end
