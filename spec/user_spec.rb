require 'spec_helper'

describe Socialcastr::User do
  describe '.search' do
    context 'when passed a valid email' do
      before :each do
        fake_socialcast_api_for(:user)
      end
      it "should return a user object" do
        Socialcastr::User.search("emily@socialcast.com").class.should == Socialcastr::User
      end
      it "should return a well parsed user " do
        Socialcastr::User.search("emily@socialcast.com").name.should == "Emily James"
      end
    end
  end
end
