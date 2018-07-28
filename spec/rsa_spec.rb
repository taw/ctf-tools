describe RSA do
  let(:p) { 367_312_396_274_349_193 }
  let(:q) { 620_751_908_961_506_923 }
  let(:n) { p * q }
  let(:e) { 0x10001 }
  let(:d) { 96235424973729198445501188703024145 }
  let(:pt) { 123456 }
  let(:ct) { pt.powmod(e, n) }

  it "encrypts" do
    expect(RSA.encrypt(pt, e: e, n: n)).to eq(ct)
  end

  it "decrypts" do
    expect(RSA.decrypt(ct, d: d, n: n)).to eq(pt)
  end

  it "derives d from p, q, e" do
    expect(RSA.derive_d(p: p, q: q, e: e)).to eq(d)
  end

  it "chinese_remainder" do
    a = rand(p)
    b = rand(q)
    c = RSA.chinese_remainder([a,b], [p,q])
    expect(c % p).to eq(a)
    expect(c % q).to eq(b)
    expect(0...n).to include(c)
  end

  it "factor_modulus" do
    expect(RSA.factor_modulus(n: n, e: e, d: d)).to eq([p, q])
  end
end
