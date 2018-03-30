describe Integer do
  it "#to_s_binary" do
    expect("A".ord.to_s_binary).to eq("A")
    expect(("W".ord*2**16 + "A".ord*2**8 + "T".ord).to_s_binary).to eq("WAT")
  end

  it "#powmod" do
    expect(1234.powmod(5678, 9012)).to eq((1234 ** 5678) % 9012)
  end

  it "#invmod" do
    expect(42.invmod(2017)).to eq(1969)
    expect((42*1969) % 2017).to eq(1)
  end

  it "#root" do
    n = 1234567812345678987654321
    expect((n**7).root(7)).to eq(n)
    expect((n**7 + 1).root(7)).to eq(nil)
  end
end
