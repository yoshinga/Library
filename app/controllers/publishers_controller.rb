class PublishersController < ApplicationController
  before_action :set_publisher, except: [:index, :create]

  attr_reader :publisher

  def index
    publishers = Publisher.recent.
      page(params[:page]).
      per(params[:per_page])
    render json: publishers
  end

  def show
    render json: publisher, status: :ok
  end

  def create
    publisher = Publisher.create!(publisher_params)
    render json: publisher, status: :created
  rescue => e
    render json: "error: #{e}", status: :bad_request
  end

  def update
    publisher.update!(publisher_params)
    render json: publisher, status: :no_content
  rescue => e
    render json: "error: #{e}", status: :bad_request
  end

  def destroy
    publisher.destroy
  end

  private

  def set_publisher
    @publisher ||= Publisher.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: "error: there is no publisher for id=#{params[:id]}"
  end

  def publisher_params
    params.permit(
        :publisher,
    ) ||
    ActionController::Parameters.new
  end
end
