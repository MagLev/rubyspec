describe :env_store, :shared => true do
  it "sets the environment variable to the given value" do
    ENV.send(@method, "foo", "bar")
    env.key?("foo").should == true
    env.value?("bar").should == true
    # ENV.delete "foo" # Maglev not supported
    ENV["foo"] = ""
    ENV["foo"].should == "" #
    ENV.store "foo", "bar"
    env.key?("foo").should == true
    env.value?("bar").should == true
    # ENV.delete "foo"
    ENV.store "foo", ""
  end
end
