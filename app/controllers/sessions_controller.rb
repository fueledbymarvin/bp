class SessionsController < ApplicationController
  def create
  	if env["omniauth.origin"] == "login"
	    if User.where(gid: env["omniauth.auth"].uid).empty?
	        flash[:error] = "You don't have an account yet."
	        redirect_to :root
	    else
	        user = User.from_omniauth(env["omniauth.auth"], false)
	        session[:user_id] = user.id
	        # source = session[:source] || :root
	        session[:source] = nil

	        redirect_to "/#/creators", :notice => "Signed in!"
	    end
	else
		user = User.from_omniauth(env["omniauth.auth"], true)
        session[:user_id] = user.id
        # source = session[:source] || :root
        session[:source] = nil

        redirect_to "/#/creators/edit/#{user.id}", :notice => "Successfully created account!"
	end
  end

  def destroy
  	reset_session
    redirect_to "/#/creators", :notice => "Signed out!"
  end
end
