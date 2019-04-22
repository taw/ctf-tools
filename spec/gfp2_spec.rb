describe GFp2 do
  describe "small prime" do
    let(:p) { 103 }
    let(:group) { GFp2[p] }
    let(:points) { group.points }
    let(:zero) { group.zero }
    let(:one) { group.one }

    describe "initializes" do
      let(:point1) { group.new }
      it "fills all default with zeroes" do
        expect(point1.a).to eq(0)
        expect(point1.b).to eq(0)
        expect(point1.p).to eq(103)
      end

      let(:point2) { group.new(42) }
      it "fills missing default with zeroes" do
        expect(point2.a).to eq(42)
        expect(point2.b).to eq(0)
        expect(point2.p).to eq(103)
      end

      let(:point3) { group.new(1234, -709) }
      it "normalizes" do
        expect(point3.a).to eq(1234 % 103)
        expect(point3.b).to eq(-709 % 103)
        expect(point3.p).to eq(103)
      end
    end

    describe "#to_s" do
      let(:point) { group.new(5, 10) }
      it do
        expect(point.to_s).to eq("GF[103^2][5,10]")
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

    describe "#/" do
      let(:point1) { group.new(12, 78) }
      let(:point2) { group.new(52, 56) }
      let(:point2_inv) { point2.inverse }
      it do
        expect(point1 / point2).to eq(point1 * point2_inv)
      end
    end

    describe "#-@" do
      let(:point1) { group.new(12, 78) }
      it do
        expect(-point1).to eq(group.new(p - 12, p - 78))
      end
    end

    describe ".points" do
      it do
        expect(points.size).to eq(p ** 2)
        expect(points.to_set.size).to eq(p ** 2)
        expect(points.map{|pt| [pt.a, pt.b]}).to match_array([*0...p].product([*0...p]))
      end
    end

    describe ".zero" do
      it do
        expect(zero).to eq(group.new(0, 0))
      end
    end

    describe ".one" do
      it do
        expect(one).to eq(group.new(1, 0))
      end
    end

    describe "#zero?" do
      it do
        expect(points.select(&:zero?)).to eq([zero])
      end
    end

    describe "#one?" do
      it do
        expect(points.select(&:one?)).to eq([one])
      end
    end

    describe "#square" do
      it do
        points.each do |pt|
          expect(pt.square).to eq(pt * pt)
        end
      end
    end

    describe "#**" do
      let(:point) { group.new(12, 78) }
      it "raised to 0 equals group element one" do
        expect(point ** 0).to eq(one)
      end

      it "raised to positive power equals repeated multiplication" do
        expect(point ** 2).to eq(point * point)
        expect(point ** 3).to eq(point * point * point)
        expect(point ** 5).to eq(point * point * point * point * point)
      end

      let(:inverse) { point.inverse }

      it "raised to negative power equals repeated multiplication of inverse" do
        expect(point ** -2).to eq(inverse * inverse)
        expect(point ** -3).to eq(inverse * inverse * inverse)
        expect(point ** -5).to eq(inverse * inverse * inverse * inverse * inverse)
      end

      it "field laws are obeyed" do
        points.each do |pt|
          next if pt.zero?
          expect(pt ** (p**2)).to eq(pt)
          expect(pt ** (p**2 - 1)).to eq(one)
          expect(pt ** (p**2 - 2)).to eq(pt.inverse)
          expect(pt ** ((p**2-2) * 17)).to eq(pt.inverse ** 17)
          expect(pt ** (p**2 - 1 - 17)).to eq(pt.inverse ** 17)
          expect(pt ** 1234).to eq(pt ** (1234 % (p**2 - 1)))
        end
      end

      # It's questionable whichever way
      it "handles zero special way" do
        expect(zero ** 0).to eq(one)
        expect(zero ** 1).to eq(zero)
        expect(zero ** 7).to eq(zero)
        expect(zero ** (p**2-2)).to eq(zero)
        expect(zero ** (p**2-1)).to eq(zero)
        expect(zero ** p).to eq(zero)
        expect{ zero ** -1 }.to raise_error(ZeroDivisionError)
      end
    end

    describe "#inverse" do
      # point ** -1 is almost the same thing, except it returns zero for this
      it "inverse of zero raises exception" do
        expect{ zero.inverse }.to raise_error(ZeroDivisionError)
      end

      it "inverse of anything else works" do
        expect(
          points.reject(&:zero?).all?{|pt| (pt * pt.inverse).one? }
        ).to eq(true)
      end
    end
  end
end
