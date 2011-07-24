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

    it "should be an instance of Array" do
      @messages.class.should == Array
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
      fake_socialcast_api_for(:message)
      @message = Socialcastr::Message.find(425)
      @flag = mock('flag', :save => true, :id => 1)
    end

    it "should assign an id to the Flag" do
      Socialcastr::Flag.should_receive(:new).and_return(@flag)
      @message.flag!
    end

    context "unflagging the message" do
      before :each do
        @message.flag = @flag
        @flag.should_receive(:destroy)
      end

      it "should not be flagged afterwards" do
        @message.unflag!
        @message.flagged?.should be_false
      end

      it "should not have a flag afterwards" do
        @message.unflag!
        @message.flag.should be_nil
      end
    end
  end

  context 'liking a message' do
    before :each do
      fake_socialcast_api_for :message
      @message = Socialcastr::Message.find(425)

      @like = mock('like', :save => true)
    end

    it 'should create a new like' do
      Socialcastr::Like.should_receive(:new).and_return(@like)
      @message.like!
    end
  end

  context "unliking a message" do
    before :each do 
      fake_socialcast_api_for :message
      @message = Socialcastr::Message.find(425)

      @like = mock('like', :unlikable => true, :save => true, :destroy => true)
      @message.stub!(:likes).and_return([@like])
    end

    it "should remove a like" do
      old_count = @message.likes.count
      @message.unlike!
      @message.likes.count.should == old_count -1
    end
  end

  context "searching for messages matching 'trying'" do
    before :each do
      fake_socialcast_api_for :messages
    end

    it "should return a message" do
      @messages = Socialcastr::Message.search("trying")
      @messages.size.should == 20
    end
  end

  context "commenting a message" do
    before :each do
      fake_socialcast_api_for :message
      @message = Socialcastr::Message.find(425)
    end

    it "should post to messages/425/comments.xml" do
      @api = mock(:api)
      response = "<comment></comment>"
      Socialcastr::Comment.stub!(:api).and_return(@api)
      @api.should_receive(:post).with("messages/425/comments", {"comment[text]" => "hallo world"}).and_return(response)
      @message.comment! :text => "hallo world"
    end
     
  end
end
