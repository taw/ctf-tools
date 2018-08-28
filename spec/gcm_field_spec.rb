describe GCMField do
  let(:a) { GCMField.random }
  let(:b) { GCMField.random }
  let(:zero) { GCMField.zero }
  let(:one) { GCMField.one }

  it "to_i" do
    expect(zero.to_i).to eq(0)
    expect(one.to_i).to eq(1 << 127)
  end

  it "from_i" do
    expect(GCMField.from_i(0)).to eq(zero)
    expect(GCMField.from_i(1 << 127)).to eq(one)
    expect(GCMField.from_i(a.to_i)).to eq(a)
  end

  it "one" do
    expect(a * one).to eq(a)
    expect(one * a).to eq(a)
  end

  it "zero" do
    expect(a * zero).to eq(zero)
    expect(zero * a).to eq(zero)
    expect(a + zero).to eq(a)
    expect(zero + a).to eq(a)
    expect(a - zero).to eq(a)
    expect(zero - a).to eq(a)
  end

  it "**" do
    expect(a ** 9).to eq(
      a * a * a * a * a * a * a * a * a
    )
    expect(a ** 1).to eq(a)
    expect(a ** 0).to eq(one)
  end

  it "divmod" do
    r, s = a.divmod(b)
    expect(r * b + s).to eq(a)
    r, s = b.divmod(a)
    expect(r * a + s).to eq(b)
    expect{ a.divmod(zero) }.to raise_error(ZeroDivisionError)
    expect(a.divmod(one)).to eq([a, zero])
  end

  it "/" do
    expect(a / b).to eq(a.divmod(b)[0])
  end

  it "%" do
    expect(a % b).to eq(a.divmod(b)[1])
  end
end
