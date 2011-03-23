require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Array#product" do
  ruby_version_is "1.8.7" do
    it "returns converted arguments using :to_ary" do
      lambda{ [1].product(2..3) }.should raise_error(TypeError)
      ar = ArraySpecs::ArrayConvertable.new(2,3)
      [1].product(ar).should == [[1,2],[1,3]]
      ar.called.should == :to_ary
    end

    it "returns the expected result" do
      [1,2].product([3,4,5],[6,8]).should == [[1, 3, 6], [1, 3, 8], [1, 4, 6], [1, 4, 8], [1, 5, 6], [1, 5, 8],
                                              [2, 3, 6], [2, 3, 8], [2, 4, 6], [2, 4, 8], [2, 5, 6], [2, 5, 8]]
    end

    it "has no required argument" do
      [1,2].product.should == [[1],[2]]
    end

    it "returns an empty array when the argument is an empty array" do
      [1, 2].product([]).should == []
    end
  end
  
 not_compliant_on :maglev do # gets OutOfMemory
  it "does not attempt to produce an unreasonable number of products" do
    a = (0..100).to_a
    lambda do
      a.product(a, a, a, a, a, a, a, a, a, a)
    end.should raise_error(RangeError)
  end
 end

  ruby_version_is "1.9" do
    describe "when given a block" do
      it "yields all combinations in turn" do
        acc = []
        [1,2].product([3,4,5],[6,8]){|array| acc << array}
        acc.should == [[1, 3, 6], [1, 3, 8], [1, 4, 6], [1, 4, 8], [1, 5, 6], [1, 5, 8],
                       [2, 3, 6], [2, 3, 8], [2, 4, 6], [2, 4, 8], [2, 5, 6], [2, 5, 8]]

        acc = []
        [1,2].product([3,4,5],[],[6,8]){|array| acc << array}
        acc.should be_empty
      end
      
      it "will ignore unreasonable numbers of products and yield anyway" do
        a = (0..100).to_a
        lambda do
          a.product(a, a, a, a, a, a, a, a, a, a)
        end.should raise_error(RangeError)
      end
    end

    describe "when given an empty block" do
      it "returns self" do
        arr = [1,2]
        arr.product([3,4,5],[6,8]){}.should equal(arr)
        arr = []
        arr.product([3,4,5],[6,8]){}.should equal(arr)
        arr = [1,2]
        arr.product([]){}.should equal(arr)
      end
    end
  end
end
