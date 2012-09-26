require './verbs.rb'
require 'minitest/autorun'

describe "Stem look up" do
  describe "all present active forms of amo, stem should be ama" do
    it "amo" do
      @input = "amo"
      create_stem.must_equal("ama")
    end

    it "amas" do
      @input = "amas"
      create_stem.must_equal("ama")
    end

    it "amat" do
      @input = "amat"
      create_stem.must_equal("ama")
    end

    it "amamus" do
      @input = "amamus"
      create_stem.must_equal("ama")
    end

    it "amatis" do
      @input = "amatis"
      create_stem.must_equal("ama")
    end

    it "amant" do
      @input = "amant"
      create_stem.must_equal("ama")
    end
  end
 
  describe "all present active forms of lego, stem should be leg" do
    it "lego" do
      @input = "lego"
      create_stem.must_equal("leg")
    end

    it "legis" do
      @input = "legis"
      create_stem.must_equal("leg")
    end

    it "legit" do
      @input = "legit"
      create_stem.must_equal("leg")
    end

    it "legimus" do
      @input = "legimus"
      create_stem.must_equal("leg")
    end

    it "legitis" do
      @input = "legitis"
      create_stem.must_equal("leg")
    end

    it "legunt" do
      @input = "legunt"
      create_stem.must_equal("leg")
    end
  end
 

end
