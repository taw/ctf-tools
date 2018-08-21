describe SHA3 do
  subject{ SHA3.hexdigest(msg) }

  describe "empty string" do
    let(:msg) { "" }
    it do
      is_expected.to eq("a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a")
    end
  end
end
