describe MD4 do
  it do
    expect(MD4.hexdigest("")).to eq "31d6cfe0d16ae931b73c59d7e0c089c0"
    expect(MD4.hexdigest("Hello, world!")).to eq "0abe9ee1f376caa1bcecad9042f16e73"
    expect(MD4.hexdigest("You have no chance to survive. Make your time.")).to eq "13576265e6f2aa3e552b7fd3787919d0"
    expect(MD4.hexdigest("All your base are belong to us.")).to eq "7b46003629bc4fe83c97e79e59e8b715"
 end

  it "#pad_message" do
    expect(MD4.pad_message("")).to eq("\x80".b + "\x00".b * 63)
    expect(MD4.pad_message("Hello, world!")).to eq("Hello, world!\x80".b + "\x00".b * 42 + "\x68\x00\x00\x00\x00\x00\x00\x00".b)
  end
end
