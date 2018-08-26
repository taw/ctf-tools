# Test vectors from http://cr.yp.to/mac/poly1305-20050329.pdf
describe Poly1305 do
  let(:m) { m_str.gsub(/\s/, "").from_hex }
  let(:c) { c_str.map{|ci| ci.to_i(16) } }
  let(:r) { r_str.split.reverse.join.to_i(16) }
  let(:k) { k_str.gsub(/\s/, "").from_hex }
  let(:mr) { mr_str.to_i(16) }

  let(:actual_c) { Poly1305.pad_and_split(m) }
  let(:actual_mr) { Poly1305.poly(r, c) }

  describe do
    let(:m_str) { "f3 f6" }
    let(:c_str) { %W[00000000000000000000000000001f6f3] }
    let(:r_str) { "85 1f c4 0c 34 67 ac 0b e0 5c c2 04 04 f3 f7 00" }
    let(:k_str) { "ec 07 4c 83 55 80 74 17 01 42 5b 62 32 35 ad d6" }
    let(:mr_str) { "321e58e25a69d7f8f27060770b3f8bb9c" }
    it do
      expect(actual_c).to eq(c)
      expect(actual_mr).to eq(mr)
    end
  end

  describe do
    let(:m_str) { "" }
    let(:c_str) { %W[] }
    let(:r_str) { "a0 f3 08 00 00 f4 64 00 d0 c7 e9 07 6c 83 44 03" }
    let(:k_str) { "75 de aa 25 c0 9f 20 8e 1d c4 ce 6b 5c ad 3f bf" }
    let(:mr_str) { "000000000000000000000000000000000" }
    it do
      expect(actual_c).to eq(c)
      expect(actual_mr).to eq(mr)
    end
  end

  describe do
    let(:m_str) { %Q[
      66 3c ea 19 0f fb 83 d8 95 93 f3 f4 76 b6 bc 24
      d7 e6 79 10 7e a2 6a db 8c af 66 52 d0 65 61 36
    ] }
    let(:c_str) { %W[
      124bcb676f4f39395d883fb0f19ea3c66
      1366165d05266af8cdb6aa27e1079e6d7
    ] }
    let(:r_str) { "48 44 3d 0b b0 d2 11 09 c8 9a 10 0b 5c e2 c2 08" }
    let(:k_str) { "6a cb 5f 61 a7 17 6d d3 20 c5 c1 eb 2e dc dc 74" }
    let(:mr_str) { "1cfb6f98add6a0ea7c631de020225cc8b" }
    it do
      expect(actual_c).to eq(c)
      expect(actual_mr).to eq(mr)
    end
  end

  describe do
    let(:m_str) { %Q[
      ab 08 12 72 4a 7f 1e 34 27 42 cb ed 37 4d 94 d1
      36 c6 b8 79 5d 45 b3 81 98 30 f2 c0 44 91 fa f0
      99 0c 62 e4 8b 80 18 b2 c3 e4 a0 fa 31 34 cb 67
      fa 83 e1 58 c9 94 d9 61 c4 cb 21 09 5c 1b f9
    ] }
    let(:c_str) { %W[
      1d1944d37edcb4227341e7f4a721208ab
      1f0fa9144c0f2309881b3455d79b8c636
      167cb3431faa0e4c3b218808be4620c99
      001f91b5c0921cbc461d994c958e183fa
    ] }
    let(:r_str) { "12 97 6a 08 c4 42 6d 0c e8 a8 24 07 c4 f4 82 07" }
    let(:k_str) { "e1 a5 66 8a 4d 5b 66 a5 f6 8c c5 42 4e d5 98 2d" }
    let(:mr_str) { "0c3c4f37c464bbd44306c9f8502ea5bd1" }
    it do
      expect(actual_c).to eq(c)
      expect(actual_mr).to eq(mr)
    end
  end
end
