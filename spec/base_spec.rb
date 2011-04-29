require 'spec_helper'

describe Socialcastr::Base do
  context 'api' do
    context 'when Socialcastr has not been configured' do
      it 'should raise an exception' do
        lambda { Socialcastr::Base.api }.should raise_error
      end
    end
    context 'when Socialcastr has been configured' do
      before :each do
        configure_socialcastr
      end
      it "should return the instance of Socialcastr::API" do
        Socialcastr::Base.api.class.should == Socialcastr::API
      end
    end
  end

  context 'find_single or find(id)' do
    before :each do
      fake_socialcast_api_for(:message) do
        @message = Socialcastr::Base.find(425)
      end
    end

    it 'should return a Socialcastr::Base object' do
      @message.class.should == Socialcastr::Base
    end
  end
  context 'find_every or find(:all)' do
    before :each do
      fake_socialcast_api_for(:message) do
        @messages = Socialcastr::Base.find(:all)
      end
    end

    it 'should return an enumerable' do
      @messages.class.should == BaseList
      lambda { @messages.first }.should_not raise_error
    end
  end
  context 'first or find(:first)' do
    before :each do
      fake_socialcast_api_for(:message) do
        @message = Socialcastr::Message.first
      end
    end

    it 'should return an object' do
      @message.class.should == Socialcastr::Message
    end
  end

  context 'last or find(:last)' do
    before :each do
      fake_socialcast_api_for(:message) do
        @message = Socialcastr::Message.last
      end
    end

    it 'should return an object' do
      @message.class.should == Socialcastr::Message
    end
  end

end
