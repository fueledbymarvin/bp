class UsersController < ApplicationController
	respond_to :json

    before_filter :correct_user, only: [:update, :destroy]

    def index
      	respond_with User.all
  	end

	def show
		respond_with inject_posts(User.find(params[:id]))
	end

	def create
		respond_with User.create(user_params)
	end

	def update
		respond_with @user.update_attributes(user_params)
	end

	def destroy
		reset_session
		respond_with @user.destroy
	end

	def current
		p current_user
		respond_with current_user
	end

private
	def user_params
	    if current_user && current_user.admin?
	    	params.require(:user).permit!
	    else
	    	params.require(:user).permit(:blurb, :year)
	    end
  	end

  	def correct_user
  		@user = User.find(params[:id])
  		if !current_user.admin && current_user != @user
  			redirect_to :root
  		end
  	end

  	def inject_posts(user)
  		user.to_json(include: :posts)
  	end
end