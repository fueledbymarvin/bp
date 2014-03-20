class UsersController < ApplicationController
    before_filter :authenticated, except: [:index, :show, :update]
    before_fileter :correct_user

    def index
      	respond_with User.all
  	end

	def show
		respond_with User.find(params[:id])
	end

	def create
		respond_with User.create(user_params)
	end

	def update
		respond_with @user.update_attributes(user_params)
	end

	def destroy
		respond_with User.destroy(params[:id])
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
end