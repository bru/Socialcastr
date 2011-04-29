require 'spec_helper'

describe Socialcastr::API do
  before :each do
    @api = Socialcastr::API.new("demo", "password", "demo.socialcast.com")
  end

  context "trying to use an invalid HTTP method" do
    it "should raise an InvalidMethod exception" do
      lambda {@api.https_request(:wrong, nil, nil)}.should raise_error(Socialcastr::InvalidMethod)
    end
  end
  context "trying to access a non existing resource" do
    it "should throw a ResourceNotFound exception" do
      Artifice.activate_with(generate_fake_endpoint("", 404)) do
        lambda { @api.get :messages }.should raise_error(Socialcastr::ResourceNotFound)
      end 
    end
  end
  context "being redirected" do
    it "should throw a Redirection exception" do
      Artifice.activate_with(generate_fake_endpoint("", 301)) do
        lambda { @api.get :messages }.should raise_error(Socialcastr::Redirection)
      end
    end
  end
  context "receiving a bad request response" do
    it "should throw a BadRequest exception" do
      Artifice.activate_with(generate_fake_endpoint("", 400)) do
        lambda { @api.get :messages }.should raise_error(Socialcastr::BadRequest)
      end
    end
  end
  context "receiving a unauthorized access response" do
    it "should throw a Unauthorized exception" do
      Artifice.activate_with(generate_fake_endpoint("", 401)) do
        lambda { @api.get :messages }.should raise_error(Socialcastr::UnauthorizedAccess)
      end
    end
  end
  context "receiving a forbidden access response" do
    it "should throw a ForbiddenAccess xception" do
      Artifice.activate_with(generate_fake_endpoint("", 403)) do
        lambda { @api.get :messages }.should raise_error(Socialcastr::ForbiddenAccess)
      end
    end
  end
  context "receiving a method not allowed response" do
    it "should throw a MethodNotAllowed exception" do
      Artifice.activate_with(generate_fake_endpoint("", 405)) do
        lambda { @api.get :messages }.should raise_error(Socialcastr::MethodNotAllowed)
      end
    end
  end
  context "receiving a resource conflict response" do
    it "should throw a ResourceConflict exception" do
      Artifice.activate_with(generate_fake_endpoint("", 409)) do
        lambda { @api.get :messages }.should raise_error(Socialcastr::ResourceConflict)
      end
    end
  end
  context "receiving a resource gone response" do
    it "should throw a ResourceGone exception" do
      Artifice.activate_with(generate_fake_endpoint("", 410)) do
        lambda { @api.get :messages }.should raise_error(Socialcastr::ResourceGone)
      end
    end
  end
  context "receiving a resource invalid response" do
    it "should throw a ResourceInvalid exception" do
      Artifice.activate_with(generate_fake_endpoint("", 422)) do
        lambda { @api.get :messages }.should raise_error(Socialcastr::ResourceInvalid)
      end
    end
  end
  context "receiving a server error response" do
    it "should throw a ServerError exception" do
      Artifice.activate_with(generate_fake_endpoint("", 500)) do
        lambda { @api.get :messages }.should raise_error(Socialcastr::ServerError)
      end
    end
  end
  context "#get" do
    it "should call Net::HTTP::Get" do
      req = Net::HTTP::Get.new("/")
      Net::HTTP::Get.should_receive(:new).and_return(req)
      @messages = nil
      fake_socialcast_api_for :message do
        @messages = @api.get :message
      end
    end

    it "should return an xml string" do
      fake_socialcast_api_for :message do
        @messages = @api.get :message
      end

      @messages.should_not be_nil
      @messages.class.should == String
    end
  end

  context "#put" do
    it "should call Net::HTTP::Get" do
      req = Net::HTTP::Put.new("/")
      Net::HTTP::Put.should_receive(:new).and_return(req)
      @messages = nil
      fake_socialcast_api_for :message do
        @messages = @api.put :message
      end
    end
  end

  context "#post" do
    it "should call Net::HTTP::Get" do
      req = Net::HTTP::Post.new("/")
      Net::HTTP::Post.should_receive(:new).and_return(req)
      @messages = nil
      fake_socialcast_api_for :message do
        @messages = @api.post :message
      end
    end
  end

  context "#delete" do
    it "should call Net::HTTP::Get" do
      req = Net::HTTP::Delete.new("/")
      Net::HTTP::Delete.should_receive(:new).and_return(req)
      @messages = nil
      fake_socialcast_api_for :message do
        @messages = @api.delete :message
      end
    end
  end

  context "#setup_https" do
    before :each do
      @https = @api.setup_https
    end

    it "should return an instance of Net::HTTP" do
      @https.class.should == Net::HTTP
    end
    it "should use ssl" do
      @https.use_ssl.should be_true
    end
    it "should not verify SSL" do
      @https.verify_mode.should == OpenSSL::SSL::VERIFY_NONE
    end

  end

  context "#build_query_string" do
    it "should return a string" do
      @api.build_query_string("").class.should == String
    end
    it "should prepend /api/ to the path" do
      @api.build_query_string("test").should match(/^\/api\/test/)
    end
    it "should append the format to the path" do
      @api.build_query_string("test").should match(/test\.xml$/)
    end
    it "should append a well formed query string when passing a parameters hash" do
      @api.build_query_string("test", :hallo => "world").should match(/\?hallo=world$/)
    end
  end
end
