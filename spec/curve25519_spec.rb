describe Curve25519 do
  let(:curve) { Curve25519.curve }
  let(:base_point) { Curve25519.base_point }
  let(:base_point_order) { Curve25519.base_point_order }

  it "base_point_order" do
    expect(curve.multiply(base_point, base_point_order)).to eq(0)
  end

  it "DH protocol" do
    a = Curve25519.random_secret
    b = Curve25519.random_secret
    ga = curve.multiply(base_point, a)
    gb = curve.multiply(base_point, b)
    gab = curve.multiply(ga, b)
    gba = curve.multiply(gb, a)
    expect(gab).to eq(gba)
  end
end
