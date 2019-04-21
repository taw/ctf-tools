describe GF2m do
  describe "AES group" do
    let(:one) { BinaryPoly.one }
    let(:x) { BinaryPoly.x }
    let(:aes_poly) { x**8 + x**4 + x**3 + x + one }
    let(:aes_field) { GF2mField.new(aes_poly) }
    let(:elements) { aes_field.elements }

    it "zero?" do
      expect(elements.select(&:zero?)).to eq([GF2m.new(0, aes_field)])
    end

    it "one?" do
      expect(elements.select(&:one?)).to eq([GF2m.new(1, aes_field)])
    end

    it "x?" do
      expect(elements.select(&:x?)).to eq([GF2m.new(2, aes_field)])
    end

    it "+" do
      elements.each do |a|
        elements.each do |b|
          expect(a+b).to eq(GF2m.new(a.value + b.value, aes_field))
        end
      end
    end

    it "-" do
      elements.each do |a|
        elements.each do |b|
          expect(a-b).to eq(a+b)
        end
      end
    end

    it "-@" do
      elements.each do |a|
        expect(-a).to eq(a)
      end
    end

    it "inverse" do
      elements.each do |a|
        if a.zero?
          expect{ a.inverse }.to raise_error(ZeroDivisionError)
        else
          expect(a * a.inverse).to be_one
        end
      end
    end

    it "*" do
      elements.each do |a|
        elements.each do |b|
          expect(a*b).to eq(GF2m.new((a.value * b.value) % aes_poly, aes_field))
        end
      end
    end

    it "/" do
      elements.each do |a|
        elements.each do |b|
          if b.zero?
            expect{a / b}.to raise_error(ZeroDivisionError)
          else
            expect(a / b).to eq(a * b.inverse)
          end
        end
      end
    end
  end
end
