describe SHA1 do
  it do
    expect(SHA1.hexdigest("")).to eq "da39a3ee5e6b4b0d3255bfef95601890afd80709"
    expect(SHA1.hexdigest("Żółw")).to eq "06ab29dba3a7836b681be9a77c10ebbf3ec5d95d"
    expect(SHA1.hexdigest("Hello, world!")).to eq "943a702d06f34599aee1f8da8ef9f7296031d699"
    expect(SHA1.hexdigest("You have no chance to survive. Make your time.")).to eq "c963d7e8676d78cce9589a9b8646748cef9d7230"
    expect(SHA1.hexdigest("All your base are belong to us.")).to eq "6e65eeb0bab294dadf2297a7aa2315703ed5b958"
    expect(SHA1.hexdigest("x" *  1000)).to eq("c3efa690fa3fdd2e2526853eed670538ea127638")
 end

  it "#pad_message" do
    expect(SHA1.padding("")).to eq("\x80".b + "\x00".b * 63)
    expect(SHA1.padding("Hello, world!")).to eq("\x80".b + "\x00".b * 42 + "\x00\x00\x00\x00\x00\x00\x00\x68".b)
    expect(SHA1.padding("x" * 1000)).to eq("\x80".b + "\x00".b * 15 + "\x00\x00\x00\x00\x00\x00\x1f\x40".b)
  end
end
