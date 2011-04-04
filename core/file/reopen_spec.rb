require File.expand_path('../../../spec_helper', __FILE__)

t_ver = "1.9"
deviates_on :maglev do
  t_ver = "1.8.7"
end

ruby_version_is t_ver do 
  describe "File#reopen" do
    before :each do
      @file = tmp('test.txt')
      @fh = nil
      touch(@file) { |f| f << "1234567890" }
    end

    after :each do
      @fh.close if @fh
      rm_r @file
    end

    it "resets the stream to a new file path" do
      @fh = File.new(@file)
      text = @fh.read
      @fh = @fh.reopen(@file, "r")
      @fh.read.should == text
    end

    it "accepts an object that has a #to_path method" do 
      @fh = File.new(@file).reopen(mock_to_path(@file), "r")
    end
  end
end
