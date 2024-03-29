class UsersController < ApplicationController
  before_filter :get_user,     :only => [:edit, :update, :destroy, :show]
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @title = @user.name
  end
  
  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to ForumLab!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end
  
  def edit
    @title = "Edit user"
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  private
    
    def get_user
      @user = User.find(params[:id])
    end
    
    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      redirect_to(root_path) unless current_user?(@user)
    end
  
    def admin_user
      redirect_to(root_path) unless (current_user.admin? && !current_user?(@user))
    end
  
end
