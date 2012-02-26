require 'spec_helper'

describe TopicsController do
  render_views
  
  describe "GET 'new'" do
    
    before(:each) do
      @user = Factory(:user)
    end

    describe "for non-signed-in users" do
      
      it "should deny access to new" do
        get :new, :id => @user
        response.should redirect_to(signin_path)
      end
      
    end
    
    describe "for signed-in users" do

      before(:each) do
         test_sign_in(@user)
      end

      it "should be successful" do
        get 'new'
        response.should be_success
      end

      it "should have the right title" do
        get 'new'
        response.should have_selector("title", :content => "New Topic")
      end

      it "should have a title field" do
        get :new
        response.should have_selector("input[name='topic[title]'][type='text']")
      end

      it "should have a post field" do
        get :new
        response.should have_selector("textarea[name='post[content]']")
      end

    end
    
  end


end
