require 'spec_helper'

describe TopicsController do
  render_views

  describe "Get 'show'" do
    before(:each) do
      @user = Factory(:user)
      @title = { :title => "Superfly saves the day"}
      @content = { :content => "What's up Superfly"}
      @post = @user.posts.create(@content)
      @topic = Topic.create!(@title)
      @post.topic = @topic
      @topic.posts << @post      
    end
    
    it "should be successful" do
      get :show, :id => @topic
      response.should be_success
    end

    it "should find the right topic" do
      get :show, :id => @topic
      assigns(:topic).should == @topic
    end

    it "should have the right title" do
      get :show, :id => @topic
      response.should have_selector("title", :content => @topic.title)
    end

    it "should have the topic headline" do
      get :show, :id => @topic
      response.should have_selector("h1", :content => @topic.title)
    end
    
    it "should contain the first post" do
      get :show, :id => @topic
      response.should have_selector("li", :content => @post.content)      
    end
    
    it "should contain the post creator's name" do
      get :show, :id => @topic
      response.should have_selector("li", :content => @user.name)      
    end
    
    describe "for non-signed-in users" do
      
      it "should not have a post field" do
        get :show, :id => @topic
        response.should_not have_selector("textarea[name='post[content]']")
      end
      
    end
    
    describe "for signed-in users" do
      
      before(:each) do
         test_sign_in(@user)
      end
      
      it "should have a post field" do
        get :show, :id => @topic
        response.should have_selector("textarea[name='post[content]']")        
      end
      
    end
    
  end
  
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

  describe "POST 'create'" do
    before(:each) do
      @title = {:title => "Superfly saves the day"}
      @content = {:content => "What's up Superfly"}
    end
    
    describe "for non-signed-in users" do
      
      it "should deny access to post :create" do
        post :create, :topic => @title, :post => @content
        response.should redirect_to(signin_path)
      end
      
    end

    describe "for signed-in users" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      it "should create a new topic" do
        lambda do
          post :create, :topic => @title, :post => @content
        end.should change(Topic, :count).by(1)
      end
    
      it "should redirect to the topic page" do
        post :create, :topic => @title, :post => @content
        response.should redirect_to(topic_path(assigns(:topic)))
      end
    
    end
    
  end

  describe "GET 'index'" do
    
    describe "for non-signed-in users" do
      it "should not have a title field" do
        get :new
        response.should_not have_selector("input[name='topic[title]'][type='text']")
      end

      it "should not have a post field" do
        get :new
        response.should_not have_selector("textarea[name='post[content]']")
      end
    end
        
    describe "for signed-in users" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user) 
        @content = {:content => "What's up Superfly"}
        @topics = []
        32.times do
          @title = Factory.next(:title)
          post :create, :topic => {:title => @title}, :post => @content
          @topics << Topic.find_by_title(@title)
        end 
      end      
        
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "Welcome")
      end
      
      it "should have an element for each of most recent topics" do
        get :index
        @topics[29..31].each do |topic|
          response.should have_selector("li", :content => topic.title)
        end
      end

      it "should paginate topics" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/topics?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/topics?page=2",
                                           :content => "Next")
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

  describe "DELETE 'destroy'" do
    
    before(:each) do
      @user = Factory(:user)
      @topic = Factory(:topic)
    end
    
    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @topic
        response.should redirect_to(signin_path)
      end
    end
    
    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @topic
        response.should redirect_to(root_path)
      end
    end
    
    describe "as an admin user" do
      before(:each) do
        @admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
        @content = {:content => "What's up Superfly"}
        @title = "Superfly saves the day"
        post :create, :topic => {:title => @title}, :post => @content
        @topic = Topic.find_by_title(@title)
      end
      
      it "should destroy the topic" do
        lambda do
          delete :destroy, :id => @topic
        end.should change(Topic, :count).by(-1)
      end
      
      it "should destroy the topic's posts" do
        lambda do
          delete :destroy, :id => @topic
        end.should change(Post, :count).by(-1)
      end
      
      it "should redirect to the topic index" do
        delete :destroy, :id => @topic
        response.should redirect_to(topics_path)
      end     
    end
    
  end

end
