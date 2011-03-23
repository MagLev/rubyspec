require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)
require File.expand_path('../shared/indexes', __FILE__)

ruby_version_is '' ... '1.9' do
 not_compliant_on :maglev do # Array#indexes is deprecated
  describe "Array#indexes" do
    it_behaves_like(:array_indexes, :indexes)
  end
 end
end
