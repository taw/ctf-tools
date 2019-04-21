describe GF2mField do
  describe "validates that polynomial is irreductible" do
    let(:x) { BinaryPoly.x }
    let(:one) { BinaryPoly.one }
    let(:aes_poly) { x**8 + x**4 + x**3 + x + one }
    let(:bad_poly) { x**8 + x**4 + x**3 + x**2 + x + one }

    it do
      expect(GF2mField.new(aes_poly)).to be_instance_of(GF2mField)
      expect{GF2mField.new(bad_poly)}.to raise_error(/Polynomial must be irreducible/)
    end
  end
end
