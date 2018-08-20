describe AES128 do
  describe "expand_key" do
    let(:key) {
      %W[2b 7e 15 16 28 ae d2 a6 ab f7 15 88 09 cf 4f 3c].map{ |u| u.to_i(16) }
    }
    let(:expanded) {
      %W[
        2b7e1516 28aed2a6 abf71588 09cf4f3c
        a0fafe17 88542cb1 23a33939 2a6c7605
        f2c295f2 7a96b943 5935807a 7359f67f
        3d80477d 4716fe3e 1e237e44 6d7a883b
        ef44a541 a8525b7f b671253b db0bad00
        d4d1c6f8 7c839d87 caf2b8bc 11f915bc
        6d88a37a 110b3efd dbf98641 ca0093fd
        4e54f70e 5f5fc9f3 84a64fb2 4ea6dc4f
        ead27321 b58dbad2 312bf560 7f8d292f
        ac7766f3 19fadc21 28d12941 575c006e
        d014f9a8 c9ee2589 e13f0cc8 b6630ca6
      ].map{ |u| u.scan(/../).map{ |v| v.to_i(16) } }.flatten
    }
    it do
      expect(AES128.expand_key(key)).to eq(expanded)
    end
  end

  describe "encrypt" do
    let(:key) { %W"2b 7e 15 16 28 ae d2 a6 ab f7 15 88 09 cf 4f 3c".map{ |u| u.to_i(16) } }
    let(:plain) { %W"32 43 f6 a8 88 5a 30 8d 31 31 98 a2 e0 37 07 34".map{ |u| u.to_i(16) } }
    let(:cipher) { %W"39 25 84 1d 02 dc 09 fb dc 11 85 97 19 6a 0b 32 ".map{ |u| u.to_i(16) } }
    it do
      expect(AES128.encrypt(key, plain)).to eq(cipher)
      expect(AES128.decrypt(key, cipher)).to eq(plain)
    end
  end
end
