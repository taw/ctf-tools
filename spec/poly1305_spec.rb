# Test vectors from http://cr.yp.to/mac/poly1305-20050329.pdf
describe Poly1305 do
  describe "#pad_and_split" do
    let(:subject) {
      Poly1305.pad_and_split(m.gsub(/\s/, "").from_hex)
    }
    let(:expected) {
      c.map{|ci| ci.to_i(16) }
    }
    describe do
      let(:m) { "f3 f6" }
      let(:c) { %W[00000000000000000000000000001f6f3] }
      it{ is_expected.to eq(expected) }
    end

    describe do
      let(:m) { "" }
      let(:c) { %W[] }
      it{ is_expected.to eq(expected) }
    end

    describe do
      let(:m) { %Q[
        66 3c ea 19 0f fb 83 d8 95 93 f3 f4 76 b6 bc 24
        d7 e6 79 10 7e a2 6a db 8c af 66 52 d0 65 61 36
      ] }
      let(:c) { %W[
        124bcb676f4f39395d883fb0f19ea3c66
        1366165d05266af8cdb6aa27e1079e6d7
      ] }
      it{ is_expected.to eq(expected) }
    end

    describe do
      let(:m) { %Q[
        ab 08 12 72 4a 7f 1e 34 27 42 cb ed 37 4d 94 d1
        36 c6 b8 79 5d 45 b3 81 98 30 f2 c0 44 91 fa f0
        99 0c 62 e4 8b 80 18 b2 c3 e4 a0 fa 31 34 cb 67
        fa 83 e1 58 c9 94 d9 61 c4 cb 21 09 5c 1b f9
      ] }
      let(:c) { %W[
        1d1944d37edcb4227341e7f4a721208ab
        1f0fa9144c0f2309881b3455d79b8c636
        167cb3431faa0e4c3b218808be4620c99
        001f91b5c0921cbc461d994c958e183fa
      ] }
      it{ is_expected.to eq(expected) }
    end
  end
end
