class WishListsController < ApplicationController
  before_action :set_wish_list, except: [:index, :create]

  attr_reader :wish_list

  def index
    wish_lists = WishList.recent.
      page(params[:page]).
      per(params[:per_page])
    render json: wish_lists
  end

  def show
    render json: wish_list, status: :ok
  end

  def create
    wish_list = WishList.create!(wish_list_params)
    render json: wish_list, status: :created
  rescue => e
    render json: "error: #{e}", status: :bad_request
  end

  def update
    wish_list.update!(wish_list_params)
    render json: wish_list, status: :ok
  rescue => e
    render json: "error: #{e}", status: :bad_request
  end

  def destroy
    wish_list.destroy
  end

  private

  def set_wish_list
    @wish_list ||= WishList.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: "error: there is no wish_list for id=#{params[:id]}", status: :bad_request
  end

  def wish_list_params
    params.permit(
        :user_id,
        :title,
        :author,
        :price,
        :link,
        :publication_date,
    ) ||
    ActionController::Parameters.new
  end
end
