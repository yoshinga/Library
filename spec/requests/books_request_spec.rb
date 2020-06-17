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
    let(:valid_attributes) do
      {
        data: {
          attributes: {
            owner_id: owner.id,
            publisher_id: publisher.id,
            rent_user_id: rent_user.id,
            purchaser_id: purchaser.id,
            status: '0',
            price: '1500',
            author: '',
            link: '',
            latest_rent_date: '',
            return_date: '',
            purchase_date: '',
            publication_date: '',
          }
        }
      }
    end

    subject do
      post books_path, params: valid_attributes, headers: { Authorization: "Bearer #{secret}" }
    end

    it 'should return created status' do
      subject
      expect(response.status).to eq(201)
    end

    it 'should register a book' do
      expect{ subject }.to change(Book, :count).by(1)
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
        data: {
          attributes: {
            owner_id: owner.id,
            publisher_id: publisher.id,
            rent_user_id: new_rent_user.id,
            purchaser_id: purchaser.id,
            status: '0',
            price: '1500',
            author: '',
            link: '',
            latest_rent_date: '',
            return_date: '',
            purchase_date: '',
            publication_date: '',
          }
        }
      }
    end

    subject do
      patch book_path(book.id), params: valid_attributes, headers: { Authorization: "Bearer #{secret}" }
    end

    it 'should update a book' do
      subject
      expect(json_data["attributes"]["rent-user-id"]).to eq(new_rent_user.id)
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
end
