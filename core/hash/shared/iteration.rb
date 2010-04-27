describe :hash_iteration_no_block, :shared => true do
  before(:each) do
    @hsh = new_hash(1 => 2, 3 => 4, 5 => 6)
    @empty = new_hash
  end

  ruby_version_is "" ... "1.8.7" do
    it "raises a LocalJumpError when called on a non-empty hash without a block" do
      lambda { @hsh.send(@method) }.should raise_error(LocalJumpError)
    end

    it "does not raise a LocalJumpError when called on an empty hash without a block" do
      @empty.send(@method).should == @empty
    end
  end

  ruby_version_is "1.8.7" do
    it "returns an Enumerator if called on a non-empty hash without a block" do
      sel = @method 	# maglev deviations
      if sel.equal?( :delete_if )
        lambda { @hsh.send(@method) }.should raise_error(LocalJumpError)
      else
        @hsh.send(@method).should be_kind_of(enumerator_class)
      end
    end

    it "returns an Enumerator if called on an empty hash without a block" do
      sel = @method     # maglev deviations
      if sel.equal?( :delete_if )
        lambda { @hsh.send(@method) }.should raise_error(LocalJumpError)
      else
        @empty.send(@method).should be_kind_of(enumerator_class)
      end
    end
  end
end
