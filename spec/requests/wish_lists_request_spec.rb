require 'rails_helper'

RSpec.describe "WishLists", type: :request do
  let(:user) { create(:user) }
  let(:secret) { 'secret_key' }
  let(:wish_list) { create(:wish_list, user_id: user.id) }

  before do
    Token.create(label: "awesome_system", key: secret)
  end

  describe '#index' do
    before do
      wish_list
    end

    subject do
      get wish_lists_path, headers: { Authorization: "Bearer #{secret}" }
    end

    it 'should return 200 status' do
      subject
      expect(response.status).to eq(200)
    end

    it 'should return proper body' do
      subject
      expect(json_data[0]["id"]).to eq(wish_list.id.to_s)
    end

    it 'should paginate results' do
      create(:wish_list)
      get wish_lists_path, headers: { Authorization: "Bearer #{secret}" }, params: { page: 2, per_page: 1 }
      expect(json_data.length).to eq(1)
    end
  end

  describe '#show' do
    subject do
      get wish_list_path(wish_list.id), headers: { Authorization: "Bearer #{secret}" }
    end

    it 'should return 200 status' do
      subject
      expect(response.status).to eq(200)
    end

    it 'should return proper body' do
      subject
      expect(json_data["id"]).to eq(wish_list.id.to_s)
    end

    it 'should error message when incorrect id' do
      get wish_list_path(1000), headers: { Authorization: "Bearer #{secret}" }
      expect(response.body).to eq("error: there is no wish_list for id=1000")
    end
  end

  describe '#create' do
    let(:valid_attributes) do
      {
        data: {
          attributes: {
            user_id: user.id,
            title: 'update_title',
            price: '1500',
            author: 'update_author',
            link: 'update_link',
            publication_date: '2020-06-10',
          }
        }
      }
    end

    subject do
      post wish_lists_path, params: valid_attributes, headers: { Authorization: "Bearer #{secret}" }
    end

    it 'should return created status' do
      subject
      expect(response.status).to eq(201)
    end

    it 'should register a wish_list' do
      expect{ subject }.to change(WishList, :count).by(1)
    end
  end

  describe '#update' do
    let(:valid_attributes) do
      {
        data: {
          attributes: {
            user_id: user.id,
            title: 'update_title',
            price: '1500',
            author: 'update_author',
            link: 'update_link',
            publication_date: '2020-06-10',
          }
        }
      }
    end

    subject do
      patch wish_list_path(wish_list.id), params: valid_attributes, headers: { Authorization: "Bearer #{secret}" }
    end

    it 'should update a wish_list' do
      subject
      expect(json_data["attributes"]["title"]).to eq("update_title")
    end
  end

  describe '#destroy' do
    subject do
      delete wish_list_path(wish_list.id), headers: { Authorization: "Bearer #{secret}" }
    end

    it 'should return 204 status' do
      subject
      expect(response.status).to eq(204)
    end

    it 'should delete a wish_list' do
      wish_list
      expect{ subject }.to change(WishList, :count).by(-1)
    end
  end
end
