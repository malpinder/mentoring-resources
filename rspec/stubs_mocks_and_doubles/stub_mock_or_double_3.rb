require 'rspec'

class Animal
  def is_a_duck?
    #do complicated calculation
    sleep 5000
    true
  end
end

class AnimalDetector

  def initialize(animal)
    @animal = animal
  end

  def duck?
    @animal.is_a_duck?
  end

end

describe AnimalDetector do
  describe "#duck?" do
    let(:duck) do
      # ??
    end
    let(:detector) { AnimalDetector.new( duck ) }
    it "returns true if the animal is a duck" do
      # ??
      detector.should be_a_duck
    end
  end
end
