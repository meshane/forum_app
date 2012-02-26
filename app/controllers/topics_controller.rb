class TopicsController < ApplicationController
  
  before_filter :authenticate, :only => [:new, :create, :destroy]  
  before_filter :admin_user,   :only => :destroy
  
  def index
    @title = "Welcome"
    @topics = Topic.all.sort_by{ |m| m.updated_at }.reverse.paginate(:page => params[:page])
    @topic = Topic.new
    @post = Post.new
  end

  def show
    @topic = Topic.find(params[:id])
    @title = @topic.title
    @posts = @topic.posts.sort_by{ |m| m.created_at }
    @post = Post.new
    @post.topic = @topic
  end

  def new
    @title = "New Topic"
    @topic = Topic.new
    @post = Post.new
  end
  
  def create
    @topic = Topic.new(params[:topic])
    @post = @topic.posts.build(params[:post])
    @post.user = current_user
    if @topic.save
      current_user.posts << @post
      redirect_to @topic
    else
      @title = "New Topic"
      render :action => 'new'
    end
  end

  def destroy
    Topic.find(params[:id]).destroy
    flash[:success] = "Topic destroyed."
    redirect_to topics_path
  end
  
  private

    def authenticate
      deny_access unless signed_in?
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin? 
    end
  
end
