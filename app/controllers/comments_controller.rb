class CommentsController < ApplicationController
  before_action :get_comment, only: [:take_top, :destroy]
  load_and_authorize_resource


  def index
    @up_comments = Comment.where(up: true).order("updated_at DESC")
    @comments = Comment.where(up: false).order("updated_at DESC").page(params[:page]).per(10)
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:success] = "创建成功"
      redirect_to comments_url
    else
      flash[:warning] = "#{@comment.errors.full_messages.join(',')}"
      redirect_to comments_url
    end
  end

  def take_top
    @comment.up = !@comment.up
    @comment.save
    redirect_to comments_path
  end

  def destroy
    Comment.delete(@comment)
    redirect_to comments_path
  end

  private

  def get_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end


end
