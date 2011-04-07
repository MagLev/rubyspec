describe :env_length, :shared => true do
  it "returns the number of ENV entries" do
    orig = ENV.to_hash
    begin
     not_compliant_on :maglev do
      ENV.clear 
     end
      ENV["foo"] = "bar"
      ENV["baz"] = "boo"
      ENV.send(@method).should >= orig.size
    ensure
     not_compliant_on :maglev do
      ENV.replace orig
     end
     deviates_on :maglev do
      ENV.delete("foo")
      ENV.delete("baz")
     end
    end
  end
end
