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
    items = predictive_search["items"].first(5)
    items_volume = items.map{ |item| item["volumeInfo"] }

    created_book = Book.create!(book_params)

    # created_book = Book.create! do |book|
    #   book.title = items_volume[1]["title"]
    #   book.price = items[1]["saleInfo"]["listPrice"]["amount"]
    #   book.author = items_volume[1]["authors"][1]
    #   book.link = items_volume[1]["infoLink"]
    #   book.publication_date = items_volume[1]["publishedDate"]
    #   book.owner_id = book_params["owner_id"]
    #   book.publisher_id = book_params["publisher_id"]
    #   book.rent_user_id = book_params["rent_user_id"]
    #   book.status = book_params["status"]
    # end

    render json: created_book, status: :created
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

  def predictive_search
    require 'net/http'
    params = 'ruby'
    uri = URI.parse("https://www.googleapis.com/books/v1/volumes\?q\=#{params}")

    begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = 5
      http.read_timeout = 10
      response = http.get(uri.request_uri)

      case response
      when Net::HTTPSuccess
        JSON.parse(response.body)
      when Net::HTTPRedirection
        'redirect'
      else
        'else'
      end

    rescue IOError => e
      logger.error(e.message)
    rescue TimeoutError => e
      logger.error(e.message)
    rescue JSON::ParserError => e
      logger.error(e.message)
    rescue => e
      logger.error(e.message)
    end
  end

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
        :title,
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
