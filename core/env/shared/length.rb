describe :env_length, :shared => true do
  it "returns the number of ENV entries" do
    orig = ENV.to_hash
    begin
      # ENV.clear Maglev.not implemented
      ENV["foo"] = "bar"
      ENV["baz"] = "boo"
      ENV.send(@method).should >= orig.size
    ensure
      # ENV.replace orig
      ENV["foo"] = nil
      ENV["baz"] = nil # maglev
    end
  end
end
