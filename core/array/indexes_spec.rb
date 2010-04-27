require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)
require File.expand_path('../shared/indexes', __FILE__)

# Array#indexes is deprecated , Maglev gives MNU, do not run this file

ruby_version_is '' ... '1.9' do
  describe "Array#indexes" do
    it_behaves_like(:array_indexes, :indexes)
  end
end
