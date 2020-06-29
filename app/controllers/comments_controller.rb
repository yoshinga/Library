class CommentsController < ApplicationController
  before_action :set_comment, except: [:create, :show]

  attr_reader :comment

  def show
    comments = Comment.where(book_id: params["id"])
    render json: comments, status: :ok
  rescue => e
    render json: "error: #{e}", status: :bad_request
  end

  def create
    comment = Comment.create!(comment_params)
    render json: comment, status: :created
  rescue => e
    render json: "error: #{e}", status: :bad_request
  end

  def update
    comment.update!(comment_params)
    render json: comment, status: :no_content
  rescue => e
    render json: "error: #{e}", status: :bad_request
  end

  def destroy
    comment.destroy
  end

  private

  def set_comment
    @comment ||= Comment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: "error: there is no comment for id=#{params[:id]}",
      status: :bad_request
  end

  def comment_params
    params.permit(
        :user_id,
        :book_id,
        :content,
    ) ||
    ActionController::Parameters.new
  end
end
