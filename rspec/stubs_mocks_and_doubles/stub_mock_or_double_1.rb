require 'rspec'

class AnimalDetector

  def initialize(animal)
    @animal = animal
  end

  def duck?
    @animal == :duck
  end

end

describe AnimalDetector do
  describe "#duck?" do
    let(:detector) { described_class.new(:duck) }
    it "returns true if the animal is a duck" do
      # ??
      detector.should be_a_duck
    end
  end
end
