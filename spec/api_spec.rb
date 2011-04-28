require 'spec_helper'

describe Socialcastr::API do

  context "without configuring it first" do
    it "should throw an exception" do
      lambda { Socialcastr.api }.should raise_error
    end
  end

  context "configured" do
    before :each do
      Socialcastr.configuration do |config|
        config.username = "username"
        config.password = "password"
        config.domain   = "demo.socialcast.com"
      end
      @api = Socialcastr.api
    end

    it "should be a Socialcastr API object" do
      @api.class.should == Socialcastr::API
    end
 
    context "having problems retrieving data" do
      it "should throw an exception" do
        Artifice.activate_with(generate_fake_endpoint("", 404)) do
          lambda { @api.get :messages }.should raise_error
        end 
      end
    end

    context "retrieving a message list" do
      before :each do 
        fake_socialcast_api_for(:messages) do
          @messages = @api.get(:messages)
        end
      end

      it "should return an xml string" do
        @messages.class.should == String
      end
    end
  end
end
