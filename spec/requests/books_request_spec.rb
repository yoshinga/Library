require 'rails_helper'

RSpec.describe "Books", type: :request do
  let(:user) { create(:user) }
  let(:secret) { 'secret_key' }
  let(:book) { create(:book) }

  before do
    Token.create(label: "awesome_system", key: secret)
  end

  describe '#index' do
    before do
      book
    end

    subject do
      get books_path, headers: { Authorization: "Bearer #{secret}" }
    end

    it 'should return 200 status' do
      subject
      expect(response.status).to eq(200)
    end

    it 'should return proper body' do
      subject
      expect(json_data[0]["id"]).to eq(book.id.to_s)
    end

    it 'should paginate results' do
      create(:book)
      get books_path, headers: { Authorization: "Bearer #{secret}" }, params: { page: 2, per_page: 1 }
      expect(json_data.length).to eq(1)
    end
  end

  describe '#show' do
    subject do
      get book_path(book.id), headers: { Authorization: "Bearer #{secret}" }
    end

    it 'should return 200 status' do
      subject
      expect(response.status).to eq(200)
    end

    it 'should return proper body' do
      subject
      expect(json_data["id"]).to eq(book.id.to_s)
    end

    it 'should error message when incorrect id' do
      get book_path(1000), headers: { Authorization: "Bearer #{secret}" }
      expect(response.body).to eq("error: there is no book for id=1000")
    end
  end

  describe '#create' do
    let(:owner) { create(:user) }
    let(:purchaser) { create(:user) }
    let(:rent_user) { create(:user) }
    let(:publisher) { create(:publisher) }
    let(:pub_id_parameter) do
      {
        owner_id: owner.id,
        publisher_id: publisher.id,
        rent_user_id: rent_user.id,
        purchaser_id: purchaser.id,
        status: '0',
        price: '3740',
        title: 'プログラミングTypeScript',
        author: 'Boris Cherny',
        link: 'https://www.oreilly.co.jp/books/9784873119045/',
        latest_rent_date: '',
        return_date: '',
        purchase_date: '',
        publication_date: '2020-03-23',
      }
    end

    let(:pub_parameter) do
      {
        owner_id: owner.id,
        rent_user_id: rent_user.id,
        purchaser_id: purchaser.id,
        status: '0',
        price: '3740',
        title: 'プログラミングTypeScript',
        author: 'Boris Cherny',
        publisher: "オライリージャパン",
        link: 'https://www.oreilly.co.jp/books/9784873119045/',
        latest_rent_date: '',
        return_date: '',
        purchase_date: '',
        publication_date: '2020-03-23',
      }
    end

    context 'when publisher attribute is :publisher_id' do
      subject do
        post books_path, params: pub_id_parameter, headers: { Authorization: "Bearer #{secret}" }
      end

      it 'should return created status' do
        subject
        expect(response.status).to eq(201)
      end

      it 'should register a book' do
        expect{ subject }.to change(Book, :count).by(1)
      end
    end


    context 'when publisher attribute is :publisher' do
      subject do
        post books_path, params: pub_parameter, headers: { Authorization: "Bearer #{secret}" }
      end

      it 'should return created status' do
        subject
        expect(response.status).to eq(201)
      end

      it 'should register a book' do
        expect{ subject }.to change(Book, :count).by(1)
      end
    end

  end

  describe '#update' do
    let(:owner) { create(:user) }
    let(:purchaser) { create(:user) }
    let(:rent_user) { create(:user) }
    let(:publisher) { create(:publisher) }
    let(:new_rent_user) { create(:user) }
    let(:valid_attributes) do
      {
        owner_id: owner.id,
        publisher_id: publisher.id,
        rent_user_id: new_rent_user.id,
        purchaser_id: purchaser.id,
        status: '0',
        price: '3740',
        title: 'Go言語でつくるインタプリタ',
        author: 'Thorsten Ball',
        link: 'https://www.oreilly.co.jp/books/9784873118222/',
        latest_rent_date: '',
        return_date: '',
        purchase_date: '',
        publication_date: '2018-06-03',
      }
    end

    subject do
      patch book_path(book.id), params: valid_attributes, headers: { Authorization: "Bearer #{secret}" }
    end

    it 'should update a book' do
      subject
      expect(json_data["attributes"]["title"]).to eq("Go言語でつくるインタプリタ")
    end
  end

  describe '#destroy' do
    subject do
      delete book_path(book.id), headers: { Authorization: "Bearer #{secret}" }
    end

    it 'should return 204 status' do
      subject
      expect(response.status).to eq(204)
    end

    it 'should delete a book' do
      book
      expect{ subject }.to change(Book, :count).by(-1)
    end
  end

  describe '#rent_book' do
    let(:owner) { create(:user) }
    let(:valid_attributes) do
      {
        uid: owner.id,
        latest_rent_date: '2020-06-25',
      }
    end

    subject do
      patch rent_book_path(book.id), params: valid_attributes, headers: { Authorization: "Bearer #{secret}" }
    end

    it 'should status 200' do
      subject
      expect(response.status).to eq(200)
    end
  end

  describe '#return_book' do
    subject do
      patch return_book_path(book.id), headers: { Authorization: "Bearer #{secret}" }
    end

    it 'should status 200' do
      subject
      expect(response.status).to eq(200)
    end
  end

  describe '#predictive_search' do
    let(:params) do
      {
        target: 'ruby'
      }
    end

    subject do
      post predictive_search_books_path, params: params, headers: { Authorization: "Bearer #{secret}" }
    end

    it 'should return proper response' do
      subject
      expect(response.status).to eq(200)
    end
  end

  describe '#create_book_search' do
    let(:owner) { create(:user) }
    let(:publisher) { create(:publisher) }
    let(:params) do
      {
        owner_id: owner.id,
        rent_user_id: nil,
        purchaser_id: owner.id,
        status: '0',
        price: '37',
        title: 'プログラミングTypeScript',
        author: 'Boris Cherny',
        publisher: "O'Reilly Japan",
        link: 'https://www.oreilly.co.jp/books/9784873119045/',
        latest_rent_date: '',
        return_date: '',
        purchase_date: '',
        publication_date: '2020-03-23',
      }
      # {
      #   "owner_id"=>"1",
      #   "rent_user_id"=>nil,
      #   "purchaser_id"=>"1",
      #   "status"=>"0",
      #   "title"=>"Effective Testing with RSpec 3",
      #   "price"=>"22.99",
      #   "author"=>"Myron Marston",
      #   "publisher"=>"Pragmatic Bookshelf",
      #   "link"=>"https://play.google.com/store/books/details?id=8g5QDwAAQBAJ&source=gbs_api",
      #   "latest_rent_date"=>"",
      #   "return_date"=>"",
      #   "purchase_date"=>"2020-06-28",
      #   "publication_date"=>"2017-08-30",
      # }
    end

    subject do
      post create_book_search_books_path, params: params, headers: { Authorization: "Bearer #{secret}" }
    end

    it 'should return proper status' do
      subject
      expect(response.status).to eq(201)
    end
  end
end
