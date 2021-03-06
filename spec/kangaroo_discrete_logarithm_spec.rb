# It's dependent on index range, not on prime, so we can pick a big one
describe KangarooDiscreteLogarithm do
  let(:bits) { 512 }
  let(:n) { OpenSSL::BN.generate_prime(bits).to_i }
  let(:min) { 1024 }
  let(:max) { 2**32 }

  let(:g) { 2 }
  let(:k) { rand(min..max) }
  let(:gk) { g.powmod(k, n) }

  it do
    u, i = KangarooDiscreteLogarithm.log(g, gk, n, min, max)
    # puts "Took #{i} steps"
    expect(u).to eq(k)
  end
end
