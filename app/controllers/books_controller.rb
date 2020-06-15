class BooksController < ApplicationController
  before_action :set_book, except: [:index, :create]

  def index
    books = Book.recent.
      page(params[:page]).
      per(params[:per_page])
    render json: books, status: :ok
  end

  def create; end
  def update; end
  def show; end

  private

  def set_book
    @book ||= Book.find(params[:id])
  end
end
