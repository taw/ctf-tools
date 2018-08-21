describe SHA3 do
  subject{ SHA3.hexdigest(msg) }

  describe "empty string" do
    let(:msg) { "" }
    it do
      is_expected.to eq("a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a")
    end
  end

  describe do
    let(:msg) { "Hello, world!" }
    it do
      is_expected.to eq("f345a219da005ebe9c1a1eaad97bbf38a10c8473e41d0af7fb617caa0c6aa722")
    end
  end

end
