class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    @title = "Sign in"
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to user  
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    @title = "Sign out"
    sign_out
    redirect_to root_path  
  end
end