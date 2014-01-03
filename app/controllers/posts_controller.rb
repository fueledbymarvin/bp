class PostsController < ApplicationController
  respond_to :json

  def index
    respond_with Post.all
  end

  def show
    respond_with Post.find(params[:id])
  end

  def create
    respond_with Post.create(post_params)
  end

  def update
    respond_with Post.update(params[:id], post_params)
  end

  def destroy
    respond_with Post.destroy(params[:id])
  end

private

  def post_params
    # if current_user && current_user.admin?
    params.require(:post).permit!
    # else
    #   params.require(:post).permit(:title)
    # end
  end

end
