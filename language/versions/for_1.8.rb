describe "The for expression" do
 not_compliant_on :maglev do
  it "repeats the loop from the beginning with 'retry'" do
    j = 0
    for i in 1..5
      j += i

      retry if i == 3 && j < 7
    end

    j.should == 21
  end
 end

 deviates_on :maglev do
   class Cretry
     def ma
       j = 0
       for i in 1..5
         j += i
   
         retry if i == 3 && j < 7
       end
   
       j
     end
   end
  it "repeats the loop from the beginning with 'retry'" do
    # gets  retry outside of rescue ...
    lambda { Cretry.new.ma.should == 21 }.should raise_error(LocalJumpError)
  end
 end

end

