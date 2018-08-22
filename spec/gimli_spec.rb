describe Gimli do
  describe "gimli" do
    let(:state) {
      %W[
        00000000 9e3779ba 3c6ef37a daa66d46
        78dde724 1715611a b54cdb2e 53845566
        f1bbcfc8 8ff34a5a 2e2ac522 cc624026
      ].map{ |u| u.to_i(16) }
    }
    let(:expected) {
      %W[
        ba11c85a 91bad119 380ce880 d24c2c68
        3eceffea 277a921c 4f73a0bd da5a9cd8
        84b673f0 34e52ff7 9e2bef49 f41bb8d6
      ].map{ |u| u.to_i(16) }
    }
    it do
      expect(Gimli.gimli(state)).to eq(expected)
    end
  end

  describe "hexdigest" do
    subject do
      Gimli.hexdigest(msg)
    end

    # https://gimli.cr.yp.to/gimli-20170627.pdf has bad test vectors
    # https://crypto.stackexchange.com/questions/51025/doubt-about-published-test-vectors-for-gimli-hash
    describe do
      let(:msg) { "There's plenty for the both of us, may the best Dwarf win." }
      let(:hash) { "4afb3ff784c7ad6943d49cf5da79facfa7c4434e1ce44f5dd4b28f91a84d22c8" }
      it { is_expected.to eq(hash) }
    end

    describe do
      let(:msg) {"If anyone was to ask for my opinion, which I note they're not, I'd say we were taking the long way around." }
      let(:hash) { "ba82a16a7b224c15bed8e8bdc88903a4006bc7beda78297d96029203ef08e07c" }
      it { is_expected.to eq(hash) }
    end

    describe do
      let(:msg) { "It's true you don't see many Dwarf-women. And in fact, they are so alike in voice and appearance, that they are often mistaken for Dwarf-men. And this in turn has given rise to the belief that there are no Dwarf-women, and that Dwarves just spring out of holes in the ground! Which is, of course, ridiculous." }
      let(:hash) { "8887a5367d961d6734ee1a0d4aee09caca7fd6b606096ff69d8ce7b9a496cd2f" }
      it { is_expected.to eq(hash) }
    end

    describe do
      let(:msg) { "" }
      let(:hash) { "b0634b2c0b082aedc5c0a2fe4ee3adcfc989ec05de6f00addb04b3aaac271f67" }
      it { is_expected.to eq(hash) }
    end
  end
end
