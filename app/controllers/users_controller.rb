class UsersController < ApplicationController
  before_action :set_user, except: [:create]

  attr_reader :user

  def create
    created_user = User.create(user_params)
    render json: created_user, status: :created
  rescue => e
    render json: "error: #{e}", status: :bad_request
  end

  def show
    render json: user, status: :ok
  end

  def update
    user.update(user_params)
    render json: '', status: :no_content
  rescue => e
    render json: "error: #{e}", status: :bad_request
  end

  def destroy
    result = user.destroy
    if result
      render json: '', status: :no_content
    else
      render json: '', status: :accepted
    end
  end

  private

  def user_params
    params.permit(:uid, :role, :nickname)
  end

  def set_user
    @user ||= User.find_by(uid: params[:id])
  end
end
