class BooksController < ApplicationController
  require 'net/http'
  before_action :set_book, only: [:show, :update, :destroy, :rent_book, :return_book]

  attr_reader :book

  def index
    books = Book.recent.
      page(params[:page]).
      per(params[:per_page])
    books.each do |b|
      b.rent_user = User.find(b.rent_user_id).nickname if b.rent_user_id
      b.purchaser = User.find(b.purchaser_id).nickname if b.purchaser_id
      b.publisher_name = b.publisher.publisher
    end
    render json: books
  end

  def show
    render json: book, status: :ok
  end

  def create
    if params["publisher"].present?
      publisher_id = Publisher.create(
        publisher: params['publisher']
      ).id
      update_book_params = book_params.merge(publisher_id: publisher_id)
    end
    created_book = Book.create!(update_book_params || book_params)

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

  def rent_book
    book.update!(
      rent_user_id: rent_params["uid"],
      latest_rent_date: rent_params["latest_rent_date"],
    )
    render status: :ok if book.rent_user_id == rent_params["uid"].to_i
  rescue => e
    render json: "error: #{e}", status: :bad_request
  end

  def return_book
    book.update_attribute(:rent_user_id, nil)
    render status: :ok if book.rent_user_id == nil
  rescue => e
    render json: "error: #{e}", status: :bad_request
  end

  def predictive_search
    items = http(params["target"])["items"].first(5)
    render json: items, status: :ok if items
  rescue => e
    render json: "error: #{e}", status: :bad_request
  end

  def create_book_search
    if params["price"].present? && params["price"].size.in?([2, 3])
      params["price"] = params["price"].to_i * 107
    end

    if params["publisher"].present?
      publisher_id = Publisher.create(
        publisher: params['publisher']
      ).id
      update_book_params = book_params.merge(publisher_id: publisher_id)
    end

    created_book = Book.create!(update_book_params || book_params)

    render json: created_book, status: :created
  rescue => e
    render json: "error: #{e}", status: :bad_request
  end

  private

  def http(params)
    uri = URI.parse("https://www.googleapis.com/books/v1/volumes?q=#{params}")

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
    params.permit(
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

  def rent_params
    params.permit(:uid, :latest_rent_date)
  end
end
