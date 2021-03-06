require 'imperator'
describe Imperator::Command do

  describe "#perform" do
    class CommandTestException < Exception; end
    class TestCommand < Imperator::Command
      action do
        raise CommandTestException.new 
      end
    end

    let(:command){TestCommand.new}
    it "runs the action block when #perform is called" do
      lambda{command.perform}.should raise_exception(CommandTestException)
    end
  end

  describe "attributes" do
    class AttributeCommand < Imperator::Command
      attribute :gets_default, :default => "foo"
      attribute :declared_attr
    end

    it "throws away undeclared attributes in mass assignment" do
      command = AttributeCommand.new(:undeclared_attr => "foo")
      lambda{command.undeclared_attr}.should raise_exception(NoMethodError)
    end

    it "accepts declared attributes in mass assignment" do
      command = AttributeCommand.new(:declared_attr => "bar")
      command.declared_attr.should == "bar"
    end

    it "allows default values to be used on commands" do
      command = AttributeCommand.new
      command.gets_default.should == "foo"
    end
    it "overrides default when supplied in constructor args" do
      command = AttributeCommand.new :gets_default => "bar"
      command.gets_default.should == "bar"
    end
  end

end

