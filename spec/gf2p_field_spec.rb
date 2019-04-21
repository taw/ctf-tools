describe GF2mField do
  let(:x) { BinaryPoly.x }
  let(:one) { BinaryPoly.one }
  let(:aes_poly) { x**8 + x**4 + x**3 + x + one }
  let(:bad_poly) { x**8 + x**4 + x**3 + x**2 + x + one }
  let(:aes_field) { GF2mField.new(aes_poly) }
  let(:bad_field) { GF2mField.new(bad_poly) }

  it "validates that polynomial is irreductible" do
    expect(aes_field).to be_instance_of(GF2mField)
    expect{bad_field}.to raise_error(/Polynomial must be irreducible/)
  end

  it "returns all elements" do
    expect(aes_field.elements.map(&:value)).to match_array((0..255).map{|i| BinaryPoly[i] })
  end
end
