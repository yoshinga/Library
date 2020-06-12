class UsersController < ApplicationController
  def create
    created_user = User.create(create_params)
    render json: created_user, status: :created
  end

  def show; end
  def update; end
  def destroy; end

  private

  def create_params
    params.require(:users).permit(:user_id, :role, :nickname)
  end
end
