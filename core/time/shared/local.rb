describe :time_local, :shared => true do
  is_solaris = false
  deviates_on :maglev do
    is_solaris = RUBY_PLATFORM.match('solaris')
  end

  ruby_version_is ""..."1.9" do
    it "creates a time based on given values, interpreted in the local time zone" do
      with_timezone("PST", -8) do
        e_a = is_solaris ? "Sat Jan 01 20:15:01 -0800 2000" : "Sat Jan 01 20:15:01 +0000 2000"
        Time.send(@method, 2000,"jan",1,20,15,1).inspect.should == e_a
      end
    end

    it "creates a time based on given C-style gmtime arguments, interpreted in the local time zone" do
      with_timezone("PST", -8) do
        e_a = is_solaris ? "Sat Jan 01 20:15:01 -0800 2000" : "Sat Jan 01 20:15:01 +0000 2000"
        time = Time.send(@method, 1, 15, 20, 1, 1, 2000, :ignored, :ignored, :ignored, :ignored)
        time.inspect.should == e_a
      end
    end

   not_compliant_on :maglev do
    it "respects rare old timezones" do  #
      with_timezone("Europe/Amsterdam") do #
        time = Time.send(@method, 1910, 1, 1)
        time.to_i.should == -1893457172
        time.inspect.should == "Sat Jan 01 00:00:00 +0019 1910"
      end
    end
   end #
  end

  ruby_version_is "1.9" do
    it "creates a time based on given values, interpreted in the local time zone" do
      with_timezone("PST", -8) do
        Time.send(@method, 2000,"jan",1,20,15,1).inspect.should == "2000-01-01 20:15:01 -0800"
      end
    end

    it "creates a time based on given C-style gmtime arguments, interpreted in the local time zone" do
      with_timezone("PST", -8) do
        time = Time.send(@method, 1, 15, 20, 1, 1, 2000, :ignored, :ignored, :ignored, :ignored)
        time.inspect.should == "2000-01-01 20:15:01 -0800"
      end
    end
  end
end
