class PostsController < ApplicationController
  respond_to :json
  before_filter :authenticated, except: [:index, :show]

  def index
    if params[:films]
      respond_with inject_user(Post.where("video IS NOT NULL"))
    else
      respond_with inject_user(Post.all)
    end
  end

  def show
    respond_with inject_user(Post.find(params[:id]))
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
    if current_user && current_user.admin?
      params.require(:post).permit!
    else
      params.require(:post).permit(:content, :title, :video, :image, :user_id)
    end
  end

  def correct_user
    @user = User.find(Post.params[:user_id])
    if !current_user.admin && current_user != @user
      redirect_to :root
    end
  end

  def inject_user(post)
    post.to_json(include: :user)
  end
end
