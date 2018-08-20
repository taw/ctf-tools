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

    let(:result) { GCM.encrypt(key.from_hex, iv.from_hex, aad.from_hex, pt.from_hex) }
    let(:actual_aad) { result[0].to_hex }
    let(:actual_ct) { result[1].to_hex }
    let(:actual_tag) { result[2].to_s(16) }

    subject do
      expect(actual_aad).to eq(aad)
      expect(actual_ct).to eq(ct)
      expect(actual_tag).to eq(tag)
    end

    describe "empty / empty" do
      let(:key) { "11754cd72aec309bf52f7687212e8957" }
      let(:iv) { "3c819d9a9bed087615030b65" }
      let(:tag) { "250327c674aaf477aef2675748cf6971" }
      it do
        subject
      end
    end

    describe "aad only - 1 block" do
      let(:key) { "77be63708971c4e240d1cb79e8d77feb" }
      let(:iv) { "e0e00f19fed7ba0136a797f3" }
      let(:aad) { "7a43ec1d9c0a5a78a0b16533a6213cab" }
      let(:tag) { "209fcc8d3675ed938e9c7166709dd946" }
      it do
        subject
      end
    end

    describe "pt only - 1 block" do
      let(:key) { "ab72c77b97cb5fe9a382d9fe81ffdbed" }
      let(:iv) { "54cc7dc2c37ec006bcc6d1da" }
      let(:pt) { "007c5e5b3e59df24a7c355584fc1518d" }
      let(:aad) { "" }
      let(:ct) { "0e1bde206a07a9c2c1b65300f8c64997" }
      let(:tag) { "2b4401346697138c7a4891ee59867d0c" }
      it do
        subject
      end
    end

    describe "multiple blocks" do
      let(:key) { "34d0b595ad6bbc3a2247653b92281044" }
      let(:iv) { "c50560b00fcede78f8b2301a" }
      let(:pt) { "aa3c338ff8bbe59579d1fd8088e3b34f" }
      let(:aad) { "20ee0faa94305c3fce1bf2497ab7b0bafbf7e8f367041efa0b83978a841d823cba074229b4db5b6edfa87afabdf1719d" }
      let(:ct) { "80cfafbf7a5dfb73fff636b9c908e8ec" }
      let(:tag) { "3676053eec80f914982f2a59e05805e0" }
      it do
        subject
      end
    end

    describe "not block aligned" do
      let(:key) { "1310738642a9d807d543898c7fef4d78" }
      let(:iv) { "3da7eed04415e72417ba05bc" }
      let(:pt) { "7ce446a8112b42422d955b1a19acf1ea492efdf810a621bc109cfc2137a853a92c06186c04d5040901a7244653100679637042" }
      let(:aad) { "f8e36a113a9a576bd7622cedbd1862fa5c2f3cda" }
      let(:ct) { "b28ccab1bbb42b6af91ca1a94d1f16ba380041c9adf58bc4835e32c784e3fc03057ed537fbe9b95e0f640f44521b696f985294" }
      let(:tag) { "179b820b7c92d72cdcdcd908d9949be7" }
      it do
        subject
      end
    end
  end
end
