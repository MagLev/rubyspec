# -*- encoding: utf-8 -*-
require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "IO#readlines" do
  before :each do
    @io = IOSpecs.io_fixture "lines.txt"
  end

  after :each do
    @io.close unless @io.closed?
  end

  ruby_version_is "1.9" do
    before :each do
      Encoding.default_external = Encoding::UTF_8
      @orig_exteenc = Encoding.default_external
    end

    after :each do
      Encoding.default_external = @orig_exteenc
    end
  end

  it "raises an IOError if the stream is closed" do
    @io.close
    lambda { @io.readlines }.should raise_error(IOError)
  end

  describe "when passed no arguments" do
    before :each do
      @sep, $/ = $/, " "
    end

    after :each do
      $/ = @sep
    end

    it "returns an Array containing lines based on $/" do
      @io.readlines.should == IOSpecs.lines_space_separator
    end
  end

  describe "when passed no arguments" do
    it "updates self's position" do
      @io.readlines
      @io.pos.should eql(137)
    end

    it "updates self's lineno based on the number of lines read" do
      @io.readlines
      @io.lineno.should eql(9)
    end

    it "does not change $_" do
      $_ = "test"
      @io.readlines
      $_.should == "test"
    end

    it "returns an empty Array when self is at the end" do
      @io.readlines.should == IOSpecs.lines
      @io.readlines.should == []
    end
  end

  describe "when passed nil" do
    it "returns the remaining content as one line starting at the current position" do
      @io.readlines(nil).should == [IOSpecs.lines.join]
    end
  end

  describe "when passed an empty String" do
    it "returns an Array containing all paragraphs" do
      @io.readlines("").should == IOSpecs.paragraphs
    end
  end

  describe "when passed a separator" do
    it "returns an Array containing lines based on the separator" do
      @io.readlines("r").should == IOSpecs.lines_r_separator
    end

    it "returns an empty Array when self is at the end" do
      @io.readlines
      @io.readlines("r").should == []
    end

    it "updates self's lineno based on the number of lines read" do
      @io.readlines("r")
      @io.lineno.should eql(5)
    end

    it "updates self's position based on the number of characters read" do
      @io.readlines("r")
      @io.pos.should eql(137)
    end

    it "does not change $_" do
      $_ = "test"
      @io.readlines("r")
      $_.should == "test"
    end

    it "tries to convert the passed separator to a String using #to_str" do
      obj = mock('to_str')
      obj.stub!(:to_str).and_return("r")
      @io.readlines(obj).should == IOSpecs.lines_r_separator
    end
  end

 not_compliant_on :maglev do
  describe "when passed a string that starts with a |" do #
    it "gets data from the standard out of the subprocess" do
      lines = IO.readlines("|sh -c 'echo hello;echo line2'")
      lines.should == ["hello\n", "line2\n"]
    end

    it "gets data from a fork when passed -" do
      lines = IO.readlines("|-")

      if lines # parent
        lines.should == ["hello\n", "from a fork\n"]
      else
        puts "hello"
        puts "from a fork"
        exit!
      end
    end
  end
 end 
end

describe "IO#readlines" do
  before :each do
    @name = tmp("io_readlines")
  end

  after :each do
    rm_r @name
  end

  it "raises an IOError if the stream is opened for append only" do
    lambda do
      File.open(@name, fmode("a:utf-8")) { |f| f.readlines }
    end.should raise_error(IOError)
  end

  it "raises an IOError if the stream is opened for write only" do
    lambda do
      File.open(@name, fmode("w:utf-8")) { |f| f.readlines }
    end.should raise_error(IOError)
  end
end

describe "IO.readlines" do
  before(:each) do
    @name = fixture __FILE__, "lines.txt"
  end

  describe "when not passed a separator" do
    before :each do
      @sep, $/ = $/, " "
    end

    after :each do
      $/ = @sep
    end

    it "returns an Array containing lines of file_name based on $/" do
      IO.readlines(@name).should == IOSpecs.lines_space_separator
    end
  end

  describe "when not passed a separator" do
    it "raises an Errno::ENOENT error when the passed file_name does not exist" do
      lambda { IO.readlines(tmp("nonexistent.txt")) }.should raise_error(Errno::ENOENT)
    end

    it "does not change $_" do
      $_ = "test"
      IO.readlines(@name)
      $_.should == "test"
    end

    it "tries to convert the passed file_name to a String using #to_str" do
      obj = mock('IO.readlines filename')
      obj.stub!(:to_str).and_return(@name)
      IO.readlines(obj).should == IOSpecs.lines
    end
  end

  describe "when passed nil as a separator" do
    it "returns the contents as a single String" do
      IO.readlines(@name, nil).should == [IOSpecs.lines.join]
    end
  end

  describe "when passed an empty String as a separator" do
    it "returns an Array containing all paragraphs" do
      IO.readlines(@name, "").should == IOSpecs.paragraphs
    end
  end

  describe "when passed an arbitrary string separator" do
    it "returns an Array containing lines of file_name based on the passed separator" do
      IO.readlines(@name, "r").should == IOSpecs.lines_r_separator
    end

    it "does not change $_" do
      $_ = "test"
      IO.readlines(@name, "r")
      $_.should == "test"
    end
  end

  describe "when passed an object as separator" do
    it "tries to convert the passed separator to a String using #to_str" do
      obj = mock('IO.readlines filename')
      obj.stub!(:to_str).and_return("r")
      IO.readlines(@name, obj).should == IOSpecs.lines_r_separator
    end
  end
end
