describe GFp2 do
  describe "small prime" do
    let(:p) { 97 }
    let(:group) { GFp2[p] }

    describe "initializes" do
      let(:point1) { group.new }
      it "fills all default with zeroes" do
        expect(point1.a).to eq(0)
        expect(point1.b).to eq(0)
        expect(point1.p).to eq(97)
      end

      let(:point2) { group.new(42) }
      it "fills missing default with zeroes" do
        expect(point2.a).to eq(42)
        expect(point2.b).to eq(0)
        expect(point2.p).to eq(97)
      end

      let(:point3) { group.new(1234, -709) }
      it "normalizes" do
        expect(point3.a).to eq(1234 % 97)
        expect(point3.b).to eq(-709 % 97)
        expect(point3.p).to eq(97)
      end
    end

    describe "#to_s" do
      let(:point) { group.new(5, 10) }
      it do
        expect(point.to_s).to eq("GF[97^2][5,10]")
      end
    end

    describe "#+" do
      let(:point1) { group.new(12, 78) }
      let(:point2) { group.new(52, 56) }
      it do
        expect(point1 + point2).to eq(group.new(12 + 52, 78 + 56))
      end
    end

    describe "#-" do
      let(:point1) { group.new(12, 78) }
      let(:point2) { group.new(52, 56) }
      it do
        expect(point1 - point2).to eq(group.new(12 - 52, 78 - 56))
      end
    end

    describe "#*" do
      let(:point1) { group.new(12, 78) }
      let(:point2) { group.new(52, 56) }
      let(:i) { group.new(0, 1) }
      it do
        expect(point1 * point2).to eq(
          group.new(12 * 52 - 78 * 56, 12 * 56 + 78 * 52)
        )
        expect(point1 * i).to eq(group.new(-78, 12))
      end
    end

    describe "#-@" do
      let(:point1) { group.new(12, 78) }
      it do
        expect(-point1).to eq(group.new(p - 12, p - 78))
      end
    end
  end
end
