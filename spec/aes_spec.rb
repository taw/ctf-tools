describe AES do
  it "add" do
    (0..255).each do |a|
      (0..255).each do |b|
        expect(AES.add(a,b)).to eq(a^b)
      end
    end
  end

  it "mul" do
    expect(AES.mul(0x57, 0x83)).to eq(0xc1)
  end

  it "safe_mul" do
    (0..255).each do |a|
      (0..255).each do |b|
        expect(AES.safe_mul(a, b)).to eq AES.mul(a, b)
      end
    end
  end

  it "mul2" do
    (0..255).each do |a|
      expect(AES.mul2(a)).to eq(AES.mul(a, 2))
    end
  end

  it "mul3" do
    (0..255).each do |a|
      expect(AES.mul3(a)).to eq(AES.mul(a, 3))
    end
  end

  it "sbox / inv_sbox" do
    expect(AES::SBOX.sort).to eq [*0..255]
    expect(AES::INV_SBOX.sort).to eq [*0..255]
    (0..255).each do |i|
      expect(AES::INV_SBOX[AES::SBOX[i]]).to eq(i)
    end
  end

  describe "shift_rows" do
    let(:state) {
      AES.transpose4x4 [
         1,  2,  3,  4,
         5,  6,  7,  8,
         9, 10, 11, 12,
        13, 14, 15, 16,
      ]
    }
    let(:shifted_state) {
      AES.transpose4x4 [
         1,  2,  3,  4,
         6,  7,  8,  5,
        11, 12,  9, 10,
        16, 13, 14, 15,
      ]
    }
    it do
      expect(AES.shift_rows(state)).to eq(shifted_state)
      expect(AES.inv_shift_rows(shifted_state)).to eq(state)
    end
  end

  describe "add_round_key" do
    let(:state) {
      [
         88,  51, 243, 147,
        149,  70, 165, 139,
        196, 177, 250, 185,
         87, 152, 207, 255,
      ]
    }
    let(:round_key) {
      [
        191,  60,  91, 223,
         41, 130, 179,  72,
        181, 125,  60,  39,
        197, 195, 167,  80,
      ]
    }
    let(:expected) {
      [
         88 ^ 191,  51 ^  60, 243 ^  91, 147 ^ 223,
        149 ^  41,  70 ^ 130, 165 ^ 179, 139 ^  72,
        196 ^ 181, 177 ^ 125, 250 ^  60, 185 ^  39,
         87 ^ 197, 152 ^ 195, 207 ^ 167, 255 ^  80,
      ]
    }
    it do
      expect(AES.add_round_key(state, round_key)).to eq(expected)
    end
  end

  describe "mix_column" do
    let(:input) { [0x87, 0x6e, 0x46, 0xa6] }
    let(:output) { [0x47, 0x37, 0x94, 0xed] }
    it do
      expect(AES.mix_column(input)).to eq(output)
      expect(AES.inv_mix_column(output)).to eq(input)
    end
  end

  describe "mix_columns" do
    let(:input) {
      AES.transpose4x4 [
        0x87, 0xf2, 0x4d, 0x97,
        0x6e, 0x4c, 0x90, 0xec,
        0x46, 0xe7, 0x4a, 0xc3,
        0xa6, 0x8c, 0xd8, 0x95,
      ]
    }
    let(:output) {
      AES.transpose4x4 [
        0x47, 0x40, 0xa3, 0x4c,
        0x37, 0xd4, 0x70, 0x9f,
        0x94, 0xe4, 0x3a, 0x42,
        0xed, 0xa5, 0xa6, 0xbc,
      ]
    }
    it do
      expect(AES.mix_columns(input)).to eq(output)
      expect(AES.inv_mix_columns(output)).to eq(input)
    end
  end
end
