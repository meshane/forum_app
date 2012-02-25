# == Schema Information
#
# Table name: topics
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Topic do
 
  before(:each) do
    @user = Factory(:user)
    @title = { :title => "Superfly saves the day"}
    @attr = { :content => "What's up Superfly"}
    @post = @user.posts.create(@attr)
  end
  
  it "should create a new instance given valid attributes" do
    Topic.create!(@title)
  end
  
  
  describe "at creation" do

    before(:each) do
      @topic = Topic.create!(@title)
    end    

    it "should have no posts" do
      @topic.posts.first.should be_nil
    end

    it "should have no users" do
      @topic.users.first.should be_nil
    end

  end
  
  describe "after connection to a post" do
    
    before(:each) do
      @topic = Topic.create!(@title)
      @post.topic = @topic
      @topic.posts << @post
    end    

    it "should have at least one post" do
      @topic.posts.first.should_not be_nil
    end
    
    it "should have the right post" do
      @topic.posts.first.should == @post
    end
    
    it "should have at least one user" do
      @topic.users.first.should_not be_nil
    end
    
    it "should have the right user" do
      @topic.users.first.should == @user
    end
    
    describe "topic.destroy" do
      before(:each) do
        @topic.destroy
      end
      
      it "should destroy posts" do
        Post.find_by_id(@post.id).should be_nil
      end

      it "should destroy user's posts" do
        @user.posts.find_by_id(@post.id).should be_nil
      end
    end
    
    
  end
 
end
