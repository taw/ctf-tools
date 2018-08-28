describe RhoFactorization do
  let(:bits) { 32 }
  let(:p) { OpenSSL::BN.generate_prime(bits).to_i }
  let(:q) { OpenSSL::BN.generate_prime(bits).to_i }
  let(:n) { p * q }

  it do
    u, i = RhoFactorization.factor(n)
    # puts "Used #{i} steps"
    expect([u, n/u]).to match_array([p, q])
  end
end
