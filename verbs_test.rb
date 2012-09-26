require './verbs.rb'
require 'minitest/autorun'

describe "Stem look up" do

  it "stem = am for amas" do
    @input = "amas"
    @endings = [[/(?<=[aei])s$/]]
    create_stem
    @stem.must_equal("ama")
  end

 

end
