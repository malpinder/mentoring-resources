require 'rspec'

describe "a test" do
  it "uses stub method" do
    foo = Object.new

    foo.stub(:a_method).and_return("Hi!")

    puts foo.a_method
  end

  it "uses mock methods" do
    foo = Object.new

    foo.should_receive(:a_method).and_return("Hi!")

    puts foo.a_method
  end

  it "doesn't do this" do
    foo = Object.new

    foo.stub(:a_method).and_return("Hi!")

    expect(foo.a_method).to eq "Hi!"
  end

  it "uses test spies" do
    foo = Object.new

    foo.stub(:a_method).and_return("Hi!")

    puts foo.a_method

    expect(foo).to have_received(:a_method)
  end
end

describe "another test" do

  class TestClass

    def self.super_length
      "Super #{SuperArray.new.length}!"
    end
  end

  class SuperArray
    def length
      0
    end
  end

  it "uses a stub_chain" do
    SuperArray.stub_chain("new.length").and_return(2)
    expect(TestClass.super_length).to eq "Super 2!"
  end

  it "uses any_instance" do
    SuperArray.any_instance.stub(:length).and_return(2)

    expect(TestClass.super_length).to eq "Super 2!"
  end

  it "uses a double" do
    test_array = double("A test array")
    test_array.stub(:length).and_return(2)

    SuperArray.stub(:new).and_return(test_array)

    expect(TestClass.super_length).to eq "Super 2!"
  end

end








