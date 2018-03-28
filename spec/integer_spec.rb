describe Integer do
  it "#to_s_binary" do
    expect("A".ord.to_s_binary).to eq("A")
    expect(("W".ord*2**16 + "A".ord*2**8 + "T".ord).to_s_binary).to eq("WAT")
  end
end
