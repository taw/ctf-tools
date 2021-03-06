describe B233 do
  let(:curve) { B233.new }
  let(:g) {
    # https://csrc.nist.gov/csrc/media/publications/fips/186/3/archive/2009-06-25/documents/fips_186-3.pdf
    B233.new(
      0x0fa_c9dfcbac_8313bb21_39f1bb75_5fef65bc_391f8b36_f8f8eb73_71fd558b,
      0x100_6a08a419_03350678_e58528be_bf8a0bef_f867a7ca_36716f7e_01f81052,
    )
  }
  let(:zero) { B233::ZERO }

  # http://point-at-infinity.org/ecc/nisttv
  let(:pt_1) { B233.new(0x00FAC9DFCBAC8313BB2139F1BB755FEF65BC391F8B36F8F8EB7371FD558B, 0x01006A08A41903350678E58528BEBF8A0BEFF867A7CA36716F7E01F81052) }
  let(:pt_2) { B233.new(0x00845FD61638BAC7D9E109A67A1F7047DC0FD9A5488A8468364BDC592AAD, 0x001B1420774ABBA2587C83900984765A8A85D776325FC39CC7823D734660) }
  let(:pt_3) { B233.new(0x0080F50A330911BD753A76364595B9F0158C4D02A85CC0E3FB6EA0AEF9FF, 0x017A49033F12EB52675E98E6432CC27104BD5C42BCBE3DAF76901C9B8743) }
  let(:pt_4) { B233.new(0x0063A1BAAAC9B4861CB6AAC5B38889A57A9629C7B04E7825CEB3FB4428A8, 0x0132A03FAE14E34053D6CCEACC117BFF8EFAF5F008D32AB626CBF9012209) }
  let(:pt_5) { B233.new(0x0194ED0CA60C85E59E7C4B69F30C6304A9F485F45032B871C4A23FFEC8C1, 0x00A52F9459C2FAB39C214061E272E1E115E1E01A98E4F09CD5A85D2698C6) }
  let(:pt_6) { B233.new(0x002EEDA3493C16230768A46AB073F6A5433FE5617BD4AFE57CC825D27276, 0x00C0C4C68F81C3BD0202A4EC28FFD13E208F4271701CD96887A5806028FC) }
  let(:pt_7) { B233.new(0x01F7D14C8236367ED87EB63873C754BD8B7EC794D966B02E26C932B29F9C, 0x008F7C01DF764B179486CFC7B5658C1829BAF50AF0DD42E822556F72CEEA) }
  let(:pt_8) { B233.new(0x001113FA420BBE57886A2FC590E99666864D0889BAE81DFA59EF439DD177, 0x00FBBEE98D579FEFEA0E811284146297E14321159B46700CDF49FFD07354) }
  let(:pt_9) { B233.new(0x015A95110DBF1D69EC0E724D01D2ACE71A521E9B327B29174E7B457E3D3D, 0x016878BA13BC5F4AD3E2BD7F577BA81A6F2F8622CD99A4DB6773737440B7) }
  let(:pt_10) { B233.new(0x01729FAFD85626066AF106C12194BAF099E7D8E602418BA81ADE075A2D6F, 0x00819FCB6BCC636E67C36E5EBF48BAFDE6AC5D2997FDEA23FD573A4A0E0A) }
  let(:pt_11) { B233.new(0x01BAB3A411AF6331F6A00C8FF0BD477D597FAD3B400F970432315955C643, 0x0133DB88896A90825A1D2E4406BC939805C8DF75E210A1AEDB58CFD8420C) }
  let(:pt_12) { B233.new(0x0013C872DC451063747ACCEDE848447DFCE495DE73867EF6E79F79670426, 0x008F1DCC98B8C4F3EEC9E3C064D5CA816C994D58C250EA3A618AA543D1F5) }
  let(:pt_13) { B233.new(0x0109164D2F7954F7B787F81801B8F54E45E094B5C3443D8EC38C04F12C5E, 0x0166A9A8F96CBF61332A380119A0249B5652F513ECC1C0225E81C98B60A1) }
  let(:pt_14) { B233.new(0x0096A33E366B8A983099CBB14A44726048C39E4AE1A5D99BC77A0EEADF18, 0x006C8ACD9CC4B4304599CAAEF7F7DF596D072F73F88DB0C54BA0B22BC33E) }
  let(:pt_15) { B233.new(0x012D3A4EC04D1665E12062DF52E95902F94B20DEBAB7DCB54E9374563493, 0x00CD64A68A05153692511BF856A643731097057BEA8CC4A4ADFC3D6E624A) }
  let(:pt_16) { B233.new(0x0089F30BF08A0B5C3535F4F4F6EA289515C7EA63E80162F0770CEBB2C33C, 0x00C2C3140E26FD866B9FBCBF12F97F40B163ECE32394CB6C5FE054B03B77) }
  let(:pt_17) { B233.new(0x00171F523C8C1F3B27BEF910A1BD799ED5A9F9ACC2DCC32C730E921256A0, 0x01A7DFF4194648DD9F464304B1FE129F20B8EC6F4E7C0CDC047D66D34196) }
  let(:pt_18) { B233.new(0x0142D69CBD05F9B5D408AFC974DC2A5D4BB388A0DC8BBFCE5092B2BAC7AC, 0x0102295224C54B2F346029A002554F398E57A7721741E834203F25EB28AC) }
  let(:pt_19) { B233.new(0x00AB5E13DDE6BB314864DFB92B35A000D226C3B57A1B219FB61DEA094864, 0x006BCCE0C83D40828EA046BA35547595DB8D2B43D2588423DA34427641E2) }
  let(:pt_20) { B233.new(0x00E585234F3B0284BA0837C16B6A6E3BCA7ECC5F92A58CE32E6BF652D68D, 0x01C230115E504B216FB5759257C9B21A7D7B2743C3A812900BA73452B399) }

  describe "valid_point?" do
    it "return true for valid points" do
      expect(zero.valid?).to be true
      expect(g.valid?).to be true
      expect(pt_1.valid?).to be true
      expect(pt_2.valid?).to be true
      expect(pt_3.valid?).to be true
      expect(pt_4.valid?).to be true
      expect(pt_5.valid?).to be true
      expect(pt_6.valid?).to be true
      expect(pt_7.valid?).to be true
      expect(pt_8.valid?).to be true
      expect(pt_9.valid?).to be true
      expect(pt_10.valid?).to be true
      expect(pt_11.valid?).to be true
      expect(pt_12.valid?).to be true
      expect(pt_13.valid?).to be true
      expect(pt_14.valid?).to be true
      expect(pt_15.valid?).to be true
      expect(pt_16.valid?).to be true
      expect(pt_17.valid?).to be true
      expect(pt_18.valid?).to be true
      expect(pt_19.valid?).to be true
      expect(pt_20.valid?).to be true
    end

    it "return false for made up points" do
      expect(B233.new(0, 0).valid?).to be false
    end
  end

  describe "+" do
    it do
      expect(pt_1 + pt_2).to eq(pt_3)
      expect(pt_7 + zero).to eq(pt_7)
      expect(zero + pt_6).to eq(pt_6)
      expect(pt_1 + pt_1).to eq(pt_2)
    end
  end

  describe "-" do
    it do
      expect(-zero).to eq(zero)
      expect(pt_7 - zero).to eq(pt_7)
      expect(zero - pt_8).to eq(-pt_8)
      expect(pt_5 - pt_3).to eq(pt_2)
      expect(pt_5 - pt_5).to eq(zero)
    end
  end

  describe "double" do
    it do
      expect(zero.double).to eq(zero)
      expect(pt_4.double).to eq(pt_4 + pt_4)
      expect(pt_3.double).to eq(pt_6)
    end
  end

  describe "*" do
    it do
      expect(pt_1 * 1).to eq(pt_1)
      expect(pt_2 * 5).to eq(pt_10)
      expect(pt_3 * 0).to eq(zero)
      expect(pt_12 * -1).to eq(-pt_12)
      expect(pt_3 * -6).to eq(-pt_18)
      expect(zero * 7).to eq(zero)
      expect(zero * -4).to eq(zero)
    end
  end
end
