describe String do
  it "#to_i_binary" do
    expect("A".to_i_binary).to eq("A".ord)
    expect("WAT".to_i_binary).to eq("W".ord*2**16 + "A".ord*2**8 + "T".ord)
  end
end
