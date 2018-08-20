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

  describe "encrypt" do
    let(:pt) { "" }
    let(:aad) { "" }
    let(:ct) { "" }

    let(:result) { GCM.encrypt(key.from_hex, iv.from_hex, aad, pt) }
    let(:actual_aad) { result[0] }
    let(:actual_ct) { result[1].to_hex }
    let(:actual_tag) { result[2].to_s(16) }

    describe do
      let(:key) { "11754cd72aec309bf52f7687212e8957" }
      let(:iv) { "3c819d9a9bed087615030b65" }
      let(:tag) { "250327c674aaf477aef2675748cf6971" }
      it do
        expect(actual_aad).to eq(aad)
        expect(actual_ct).to eq(ct)
        expect(actual_tag).to eq(tag)
      end
    end
  end
end
