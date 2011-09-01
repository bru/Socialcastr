require 'spec_helper'

describe Socialcastr::SAX::ActiveResource do
  describe "#parse" do
    before do
      @active_resource = Socialcastr::SAX::ActiveResource.new
      @parser = Nokogiri::XML::SAX::Parser.new(@active_resource)
    end

    context "an empty document with a root 'message' element" do
      it "should return a nil object" do
        xml = "<message></message>"
        @parser.parse(xml)
        @active_resource.data.should be_nil
      end
    end
    context "a document with a nil element" do
      it "should make the nil element accessible" do
        xml = "<message><id>1</id><rating nil=\"true\"></rating></message>"
        @parser.parse(xml)
        @active_resource.data.rating.should be_nil
      end
    end

    context "a document with a string element" do
      it "should make the element accessible as a string" do
        xml = "<message><title>Hello World!</title></message>"
        @parser.parse(xml)
        @active_resource.data.title.class.should == String
        @active_resource.data.title.should == "Hello World!"
      end
    end

    context "a document with a true boolean element" do
      it "should make the element accessible as a boolean" do
        xml = "<message><ratable type=\"boolean\">true</ratable></message>"
        @parser.parse(xml)
        @active_resource.data.ratable.should be_true
      end
    end

    context "a document with a false boolean element" do
      it "should make the element accessible as a boolean" do
        xml = "<message><ratable type=\"boolean\">false</ratable></message>"
        @parser.parse(xml)
        @active_resource.data.ratable.should be_false
      end
    end

    context "a document with an array of 2 string elements" do
      before do
        xml = "<message><tags type=\"array\"><tag>first</tag><tag>second</tag></tags></message>"
        @parser.parse(xml)
      end
      it "should make the array accessible through the collection name" do
        @active_resource.data.tags.class.should == Array
      end
      it "should have an array containing 2 elements" do
        @active_resource.data.tags.size.should == 2
      end
      it "should have an array of objects of class string" do
        @active_resource.data.tags.first.class.should == String
      end
    end

    context "a document with an array of 2 complex elements" do
      before do 
        xml = "<message><tags type=\"array\"><tag><name>first</name></tag><tag><name>second</name></tag></tags></message>"
        @parser.parse(xml)
      end
      it "should make the array accessible through the c ollection name" do
        @active_resource.data.tags.class.should == Array
      end
      it "should have an array containing 2 elements" do
        @active_resource.data.tags.size.should == 2
      end
      it "should have an array of objects of class derived from the element name" do
        @active_resource.data.tags.first.class.should == Socialcastr::Tag
      end
    end

    context "a document with an array as the root element" do
      before do
        xml = "<messages type=\"array\"><msg>hello</msg><msg>world</msg></messages>"
        @parser.parse(xml)
      end
      it "should return an array" do
        @active_resource.data.class.should == Array
      end
      it "should grant access to each element" do
        @active_resource.data.first.should == "hello"
      end
    end

    context "a document with a complex element" do
      before do 
        xml = "<message><user><username>johndoe</username><name>John Doe</name></user></message>"
        @parser.parse(xml)
      end
      it "should grant access to the inside element as an object of class derived from the element name" do
        @active_resource.data.user.class.should == Socialcastr::User
      end
      it "should grant access to nested elements as methods of the parent class" do
        @active_resource.data.user.username.should == "johndoe"
      end
    end
  end 
end
