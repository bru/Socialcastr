require 'spec_helper'

describe Socialcastr do
  context 'configuration' do
    context 'called without a block' do
      before :each do
        @config = Socialcastr.configuration
      end
      it 'should return a Socialcastr::Configuration instance' do
        @config.class.should == Socialcastr::Configuration
      end
    end
    context 'called with a block' do
      before :each do
        @called = nil
        Socialcastr.configuration do |config|
          @called = config
        end
      end
      it 'should call the block' do
        @called.should_not be_nil
      end
      it 'should pass a configuration instance to the block' do
        @called.equal?(Socialcastr::Configuration.instance).should be_true
      end
      context 'pointing to a yaml ile' do
        before :each do
          Socialcastr.configuration do |config|
            config.config_file = File.join(File.dirname(__FILE__), 'fixtures', 'demo_config.yml')
          end
        end

        it 'should load the configuration attributes from the file' do
          Socialcastr.configuration.username.should == "file_demo"
          Socialcastr.configuration.password.should == "password"
          Socialcastr.configuration.domain.should == "demo.socialcast.com"
        end
      end
    end
  end

  context 'api' do
    context 'called without having configured Socialcastr' do
      it 'should raise an error' do
        lambda { Socialcastr.api }.should raise_error
      end
    end
    context 'called after configuring Socialcastr' do
      before :each do
        configure_socialcastr
        @api = Socialcastr.api
      end
      it 'should return a new Socialcastr::API instance' do
        @api.class.should == Socialcastr::API
      end
    end
  end
end
