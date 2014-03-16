class PostsController < ApplicationController
  def index
    @posts = Post.page(params[:page]).order('created_at DESC')
    @players = Ladder.new('all').find_by_page(1).first(10)
  end

  def show
    @post = Post.find(params[:id])
  end
end
