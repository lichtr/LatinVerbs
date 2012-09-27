require './verbs.rb'
require 'minitest/autorun'

describe "Stem look up" do
  describe "all present active forms of amo, stem should be ama" do
   # it "amo" do    # at this point, the program cannot solve this problem
   #   @input = "amo"
   #   create_stem.must_equal("ama")
   # end

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

    it "legunt" do
      @input = "legunt"
      create_stem.must_equal("legu")
    end
  end
end

describe "search the db" do
  it "should return right hash" do
    look_up_stem("ama").must_equal({"ama1" => ["1", "ama", "amav", "amat"]})
  end

  it "should return right hash" do
    look_up_stem("leg").must_equal({"leg3" => ["3", "leg", "leg", "lect"]})
  end

  it "should return empty hash" do
    look_up_stem("legi").must_equal({})
  end
end

describe "iterate search" do
  it "should return leg3" do
    @input_wo_ending = "legi"
    iterate_db_search.must_equal({"leg"=>{"leg3"=>["3", "leg", "leg", "lect"]}}) 
  end

  it "PROBLEM: first person of a conj, pr, ind" do
    @input_wo_ending = "am"
    iterate_db_search.must_equal({"ama"=>{"ama1"=>["1", "ama", "amav", "amat"]}})
  end

  it "PROBLEM: pr, con, E" do

  end

  it "should return 2 hits" do

  end
end
