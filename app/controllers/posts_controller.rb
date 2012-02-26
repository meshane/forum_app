class PostsController < ApplicationController
  
  before_filter :authenticate
    
  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(params[:post])
    @post.user = current_user
    if @post.save
      current_user.posts << @post
    end
    redirect_to @topic
    
  end
  
  private

    def authenticate
      deny_access unless signed_in?
    end
  
end
