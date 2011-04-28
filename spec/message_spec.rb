require 'spec_helper'

describe Socialcastr::Message do
  context "fetching a specific message from socialcast" do
    before :all do
      fake_socialcast_api_for(:message) do
        @message = Socialcastr::Message.find(425)
      end
    end 

    it "should return a Message object" do
      @message.class.should == Socialcastr::Message
     end

    it "should have a proper title" do
      @message.title.should == "trying out the api"
    end

    it "should have an id" do
      @message.id.should_not be_nil
      @message.id.should == 425
    end
    it "should have a body" do
      @message.body.should_not be_nil
    end

    it "should have a user" do
      @message.user.should_not be_nil
      @message.user.class.should == Socialcastr::User
    end

    it "should have a collection of groups" do
      @message.groups.class.should == Array
    end

    it "should belong to a well formed group" do
      @message.groups.first.class.should == Socialcastr::Group
    end

    it "should have a source" do
      @message.source.should_not be_nil
      @message.source.class.should == Socialcastr::Source
    end

  end

  context "fetching a page's worth of messages" do
    before :each do
      fake_socialcast_api_for(:messages) do
        @messages = Socialcastr::Message.all
      end
    end

    it "should be an instance of MessageList" do
      @messages.class.should == MessageList
    end

    it "should be a collection of 20 Socialcastr::Message objects" do
      @messages.size.should == 20
    end

    it "should be possible to fetch the first item" do
      @messages.first.should_not be_nil
      @messages.first.class.should == Socialcastr::Message
    end

    it "should contain well formed Message objects" do
      @messages.first.title.should == "trying out the api"
    end 
  end
end
