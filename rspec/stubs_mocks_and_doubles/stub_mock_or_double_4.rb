require 'rspec'

class Animal
  attr_accessor :legs, :sound

  def legs
    @legs ||= rand(4)
  end

  def sound
    @sound ||= (rand(2).even? ? :quack : :neigh)
  end
end

class AnimalDetector

  def initialize(animal)
    @animal = animal
  end

  def duck?
    goes_quack? && has_two_legs?
  end

  private

  def goes_quack?
    @animal.sound == :quack
  end

  def has_two_legs?
    @animal.legs == 2
  end
end

describe AnimalDetector do
  describe "#duck?" do
    let(:duck) do
      #?? 
    end
    let(:detector) { AnimalDetector.new( duck ) }
    it "returns true if the animal has two legs and goes quack" do
      # ??
      detector.should be_a_duck
    end
  end
end
