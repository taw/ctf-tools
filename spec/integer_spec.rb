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

  it "#root_ceil" do
    n = 1234567812345678987654321
    expect((n**7).root_ceil(7)).to eq(n)
    expect((n**7 - 1).root_ceil(7)).to eq(n)
    expect((n**7 + 1).root_ceil(7)).to eq(n+1)
  end

  describe "chinese_remainder" do
    let(:p) { 367_312_396_274_349_193 }
    let(:q) { 620_751_908_961_506_923 }
    let(:n) { p * q }

    it  do
      a = rand(p)
      b = rand(q)
      c = Integer.chinese_remainder([a,b], [p,q])
      expect(c % p).to eq(a)
      expect(c % q).to eq(b)
      expect(0...n).to include(c)
    end
  end

  # base is not necessarily generator, so we can't check if k is same
  describe "discrete log algorithms" do
    let(:base) { rand(2...modulus) }
    let(:k) { rand(2...modulus) }
    let(:target) { base.powmod(k, modulus) }

    describe "discrete_log_linear" do
      let(:modulus) { 1621 }
      let(:k2) { target.discrete_log_linear(base, modulus) }
      it do
        expect(base.powmod(k, modulus)).to eq(base.powmod(k2, modulus))
      end
    end

    describe "discrete_log_bsgs" do
      let(:modulus) { 2323367 }
      let(:k2) { target.discrete_log_bsgs(base, modulus) }
      it do
        expect(base.powmod(k, modulus)).to eq(base.powmod(k2, modulus))
      end
    end

    describe "discrete_log_bsgs_primepow"  do
      let(:modulus) { prime ** pow }
      let(:prime) { 2323367 }
      let(:pow) { 8 }
      let(:k2) { target.discrete_log_bsgs_primepow(base, prime, pow) }
      it do
        expect(base.powmod(k, modulus)).to eq(base.powmod(k2, modulus))
      end
    end
  end
end
