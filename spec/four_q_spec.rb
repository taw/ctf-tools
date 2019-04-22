describe FourQ do
  let(:field) { FourQ::Field }
  let(:zero) { FourQ::Zero }

  # https://github.com/bifurcation/fourq/blob/master/impl/curve4q.py
  let(:gx) { field.new(0x1A3472237C2FB305286592AD7B3833AA, 0x1E1F553F2878AA9C96869FB360AC77F6) }
  let(:gy) { field.new(0x0E3FEE9BA120785AB924A2462BCBB287, 0x6E1C4AF8630E024249A7C344844C8B5C) }
  let(:g) { FourQ.new(gx, gy) }

  describe "valid?" do
    it do
      expect(zero).to be_valid
      expect(g).to be_valid
      expect(FourQ.new(field.new(123), field.new(456))).to_not be_valid
    end
  end
end
