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
      expect(JSON.parse(response.body)[0]["id"]).to eq(book.id)
    end

    it 'should paginate results' do
      create_list(:book, 4)
      get books_path,
        params: { page: 2, per_page: 1 },
        headers: { Authorization: "Bearer #{secret}" }
      binding.pry
      expect
    end
  end
end
