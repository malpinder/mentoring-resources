require 'rspec'

class PhenotypeFetcher
  def self.get!
    # get phenotype information
    sleep 5000
  end
end

class AnimalDetector

  def initialize(animal)
    @animal = animal
  end

  def duck?
    PhenotypeFetcher.get!
    goes_quack? && has_two_legs?
  end

  private

  def goes_quack?
    true
  end

  def has_two_legs?
    true
  end

end

describe AnimalDetector do
  describe "#duck?" do
    let(:detector) { AnimalDetector.new(:duck) }
    it "returns true if the animal is a duck" do
      # ??
      detector.should be_a_duck
    end
  end
end
