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

  context 'flagging a message' do
    before :each do
      fake_socialcast_api_for(:message) do 
        @message = Socialcastr::Message.find(425)
      end
      @api = mock(:api)
      response = "<flag><id>3333</id></flag>"
      Socialcastr::Message.stub!(:api).and_return(@api)
      @api.stub!(:post).and_return(response)
    end

    it "should assign an id to the Flag" do
      @message.flag!
      @message.flag.id.should == 3333
    end

    context "unflagging the message" do
      before :each do
        @message.flag!
        @api.should_receive(:delete).with("/messages/425/flags/3333").and_return("")
      end

      it "should not have a flag afterwards" do
        @message.unflag!
        @message.flag.id.should be_nil
      end
    end
  end

  context 'liking a message' do
    before :each do
      fake_socialcast_api_for :message do 
        @message = Socialcastr::Message.find(425)
      end

      @api = mock(:api)
      response = "<like><id>2222</id><unlikable>true</unlikable></like>"
      Socialcastr::Message.stub!(:api).and_return(@api)
      @api.stub!(:post).and_return(response)
    end

    it 'should create a new like' do
      old_count = @message.likes.count
      @message.like!
      @message.likes.count.should == old_count + 1
    end

    it 'should assign an id the the new like' do
      @message.like!
      @message.likes.last.id.should == 2222
    end
  end

  context "unliking a message" do
    before :each do 
      fake_socialcast_api_for :message do 
        @message = Socialcastr::Message.find(425)
      end

      @api = mock(:api)
      response = "<like><id>2222</id><unlikable>true</unlikable></like>"
      Socialcastr::Message.stub!(:api).and_return(@api)
      @api.stub!(:post).and_return(response)
      @api.stub!(:delete).and_return("")
      @message.like!
    end

    it "should remove a like" do
      old_count = @message.likes.count
      @message.unlike!
      @message.likes.count.should == old_count -1
    end
  end

  context "searching for messages matching 'trying'" do
    before :each do
      fake_socialcast_api_for :message
    end

    it "should return a message" do
      @messages = Socialcastr::Message.search(:q=>"trying")
      @messages.size.should == 1
    end
  end

  context "commenting a message" do
    before :each do
      fake_socialcast_api_for :message do
        @message = Socialcastr::Message.find(425)
      end
    end

    it "should post to messages/425/comments.xml" do
      @api = mock(:api)
      response = "<comment></comment>"
      Socialcastr::Message.stub!(:api).and_return(@api)
      @api.should_receive(:post).with("/messages/425/comments", {"comment[text]" => "hallo world"}).and_return(response)
      @message.comment! :text => "hallo world"
    end
     
  end
end
