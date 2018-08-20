describe GCM do
  describe "mul" do
    let(:a) { 0x952b2a56a5604ac0b32b6656a05b40b6 }
    let(:b) { 0xdfa6bf4ded81db03ffcaff95f830f061 }
    let(:c) { 0xda53eb0ad2c55bb64fc4802cc3feda60 }

    it do
      expect(GCM.mul_reflect(a,b).to_s(16)).to eq(c.to_s(16))
      expect(GCM.mul(a,b).to_s(16)).to eq(c.to_s(16))
    end
  end
end
