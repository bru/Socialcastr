require 'spec_helper'

describe Socialcastr::Configuration do

  it 'should be a singleton' do
    lambda {Socialcastr::Configuration.new }.should raise_error

    config1 = Socialcastr::Configuration.instance
    config2 = Socialcastr::Configuration.instance
    config1.equal?(config2).should be_true
  end

  context 'when called for the first time' do
    before :each do
      @config = Socialcastr::Configuration.instance
    end
    it 'should not set a username' do
      @config.username.should be_nil
    end

    it 'should not set a password' do
      @config.password.should be_nil
    end

    it 'should not set a domain' do
      @config.domain.should be_nil
    end

    it 'should not be ready' do
      @config.ready?.should be_false
    end

    context 'then setting the username' do
      before :each do
        @config.username = "demo"
      end

      it 'should have a username' do
        @config.username.should == "demo"
      end
    end

    context 'then setting the password' do
      before :each do
        @config.password = "password"
      end

      it 'should have a username' do
        @config.password.should == "password"
      end
    end

    context 'then setting the domain' do
      before :each do
        @config.domain = "demo"
      end

      it 'should have a username' do
        @config.domain.should == "demo"
      end
    end
  end

  context 'when properly configured' do
    before do
      @config = Socialcastr::Configuration.instance
      @config.username = "demo"
      @config.password = "password"
      @config.domain   = "demo.socialcast.com"
    end

    it 'should be ready' do
      @config.ready?.should be_true
    end
    context '#reset' do
      before :each do
        @config.reset
      end

      it 'should have no password' do
        @config.password.should be_nil
      end
      it 'should have no username' do
        @config.username.should be_nil
      end

      it 'should have no domain' do
        @config.domain.should be_nil
      end
      it 'should not be ready' do
        @config.ready?.should be_false
      end
    end

  end

end
