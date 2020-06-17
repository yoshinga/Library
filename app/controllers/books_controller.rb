class BooksController < ApplicationController
  before_action :set_book, except: [:index, :create]

  attr_reader :book

  def index
    books = Book.recent.
      page(params[:page]).
      per(params[:per_page])
    render json: books
  end

  def show
    render json: book, status: :ok
  end

  def create
    book = Book.create!(book_params)
    render json: book, status: :created
  rescue => e
    render json: "error: #{e}", status: :bad_request
  end

  def update
    book.update!(book_params)
    render json: book, status: :ok
  rescue => e
    render json: "error: #{e}", status: :bad_request
  end

  def destroy
    book.destroy
  end

  private

  def predictive_search; end

  def set_book
    @book ||= Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: "error: there is no book for id=#{params[:id]}"
  end

  def book_params
    params.require(:data).require(:attributes).
      permit(
        :owner_id,
        :rent_user_id,
        :purchaser_id,
        :publisher_id,
        :status,
        :price,
        :author,
        :link,
        :latest_rent_date,
        :return_date,
        :purchase_date,
        :publication_date
    ) ||
    ActionController::Parameters.new
  end
end
