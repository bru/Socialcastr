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

  context 'creating a new object with new()' do
    it 'should return a new instance' do
      class Post < Socialcastr::Base; end
      post = Post.new
      post.should_not be_nil
      post.class.should == Post
    end
    
    context 'for a class that has an element \'author\'' do
      before :each do
        class Post < Socialcastr::Base
          element 'author'
        end
        @post = Post.new
      end

      it 'should be possible to access the author attribute' do
        lambda { @post.author }.should_not raise_error
      end

      it 'should not initialize the author attribute' do
        @post.author.should be_nil
      end
    end
  end

  context 'initializing a new object with author="john doe"' do
    before :each do
      class Post < Socialcastr::Base
        id_element :id
        element 'author'
      end
      @post = Post.new(:author => "john doe")
    end

    context '#author' do
      it 'should return "john doe"' do
        @post.author.should == "john doe"
      end
    end

    context '#new?' do
      it 'should return true' do
        @post.new?.should be_true
      end
    end

    context '#id' do
      it 'should be nil' do
        @post.id.should be_nil
      end
    end

    context '#to_params' do
      it 'should return a Hash ' do
        @post.to_params.class.should == Hash
      end
    end

    context '#param_name' do
      it 'should return a string like model_name[variable_name]' do
        @post.param_name("@author").should == "post[author]"
      end
    end

    context "#copy_attributes_from_object" do
      it "should copy the instance variables of on another object's to the current one" do
        @another_post = Post.new(:author => "jane doe")
        @post.copy_attributes_from_object(@another_post)
        @post.author.should == "jane doe"
      end
    end

    context 'saving it with #save' do
      before :each do 
        @api = mock('api', :post => "")
        Socialcastr.stub!(:api).and_return(@api)
      end
      it 'should POST to the socialcast api' do
        response = "<post><id>4</id><author>john doe</author></post>"
        @api.should_receive(:post).and_return(response)
        @post.save
        @post.id.should == 4
      end

    end
  end

  context 'find_single or find(id)' do
    before :each do
      fake_socialcast_api_for(:message) do
        @message = Socialcastr::Message.find(425)
      end
    end

    it 'should return a Socialcastr::Base object' do
      @message.class.should == Socialcastr::Message
    end

    it 'should not be new' do
      @message.new?.should be_false
    end

    context 'after modifying one attribute' do
      before :each do
        @message.title = 'new title'
      end

      it 'the attribute should be changed' do
        @message.title.should == "new title"
      end

      context 'saving the object with #save' do
        it 'should PUT to the Socialcast API' do
          @api = mock('api', :post => "")
          Socialcastr::Message.stub!(:api).and_return(@api)
          response = "<message></message>"
          @api.should_receive(:put).and_return(response)
          @message.save
        end 
      end
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

  context 'model_name' do
    it 'should return a lowercase string containing the object\'s classname' do
      class Tree < Socialcastr::Base; end
      Tree.model_name.should == 'Tree'
    end

    it 'should not include any module or prefix' do
      class Socialcastr::Tree < Socialcastr::Base; end
      Socialcastr::Tree.model_name.should == 'Tree'
    end
  end

  context 'prefix' do
    context 'being passed {:post_id => 3} as arguments' do
      it 'should return posts/3/' do
        Socialcastr::Base.prefix(:post_id => 3).should == 'posts/3/'
      end
    end
  end

  context 'collection_name' do
    it 'should return a pluralized and downcase string' do
      Socialcastr::Base.collection_name.should == 'bases'
    end
  end

  context 'collection_class' do
    before do
      class Post < Socialcastr::Base; end
    end
    it 'should return a class' do
      Post.collection_class.class.should == Class
    end

    it 'should return a class that inherits from Socialcastr::Collection' do
      Post.collection_class.superclass.should == Socialcastr::Collection
    end
  end

  context 'element_path' do
    context 'with 5 as an argument' do
      it 'should return collection_name/5' do
        class Post < Socialcastr::Base; end
        Post.element_path(5).should == '/posts/5'
      end
    end
  end

  context 'collection_path' do
    it 'should return collection_name' do
      class Post < Socialcastr::Base; end
      Post.collection_path.should == '/posts'
    end
  end

end
