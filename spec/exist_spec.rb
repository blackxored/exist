require 'spec_helper'

RSpec.describe Exist do
  it "specifies the version" do
    expect(subject.const_get('VERSION')).to_not be_empty
  end
end
