class UsersController < ApplicationController
    #before_filter :authenticated, except: [:new]

    def create
        redirect_to "/auth/google?origin=signup"
    end
end