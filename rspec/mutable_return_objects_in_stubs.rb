require 'rspec'

describe "Returning mutable objects" do

  let(:rubber_duck) { double("A rubber duck") }
  let(:sound) { "Quack" }

  before do
    rubber_duck.stub(:sound).and_return(sound)
  end

  it "returns what you would expect" do
    rubber_duck.sound.should eq "Quack"
  end

  it "can be mutated in a single spec" do
    sound.upcase!
    rubber_duck.sound.should eq "QUACK"
  end

  it "also works if you aren't using let blocks" do
    neigh = "Neigh"
    rubber_duck.stub(:sound).and_return(neigh)
    neigh.upcase!
    rubber_duck.sound.should eq "NEIGH"
  end

end
