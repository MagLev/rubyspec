require File.expand_path('../../../spec_helper', __FILE__)
require 'matrix'

describe "Matrix#singular?" do
  ruby_bug "#1020", "1.8.7" do
    it "returns true for singular matrices" do
      m = Matrix[ [1,2,3], [3,4,3], [0,0,0] ]
      m.singular?.should be_true

      m = Matrix[ [1,2,9], [3,4,9], [1,2,9] ]
      m.singular?.should be_true
    end

    it "returns false if the Matrix is regular" do
      Matrix[ [0,1], [1,0] ].singular?.should be_false
    end
  end

 do_test = true
 deviates_on :maglev do
   do_test = false
   ruby_version_is "1.8.8" do
     do_test = false # 1.8.7 does not have Matrix.empty
   end
 end
 if do_test
  ruby_bug "", "1.8.7" do
    it "returns false for an empty 0x0 matrix" do
      Matrix.empty(0,0).singular?.should be_false
    end

    it "raises an error for rectangular matrices" do
       lambda {
         Matrix[[1], [2], [3]].singular?
       }.should raise_error(Matrix::ErrDimensionMismatch)

       lambda {
         Matrix.empty(3,0).singular?
       }.should raise_error(Matrix::ErrDimensionMismatch)
     end
  end
 end
end
