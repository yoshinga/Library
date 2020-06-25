require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:secret) { 'secret_key' }
  let(:user) { create(:user) }

  before do
    Token.create(label: "awesome_system", key: secret)
  end

  describe '#create' do
    let (:create_params) do
      {
        users: {
          uid: '1',
          role: '1',
          nickname: 'bob',
        }
      }
    end

    subject do
      post users_path, params: create_params, headers: {
        Authorization: "Bearer #{secret}"
      }
    end

    it 'should return created status' do
      subject
      expect(response.status).to eq(201)
    end

    it 'should register a user' do
      expect { subject }.to change(User, :count).by(1)
    end
  end

  describe '#show' do
    subject do
      get user_path(user.uid), headers: {
        Authorization: "Bearer #{secret}"
      }
    end

    it 'should return 200 status' do
      subject
      expect(response.status).to eq(200)
    end

    it 'should return proper a user' do
      user_id = User.find_by(uid: user.uid).id
      subject
      expect(JSON.parse(response.body)["id"]).to eq(user_id)
    end
  end

  describe '#update' do
    let(:update_params) do
      {
        users: {
          nickname: 'updated_great_name',
        }
      }
    end

    subject do
      patch user_path(user.uid), params: update_params, headers: {
        Authorization: "Bearer #{secret}"
      }
    end

    it 'should return updated status' do
      subject
      expect(response.status).to eq(204)
    end

    it 'should register a user' do
      subject
      updated_user = User.find_by(uid: user.uid)
      expect(updated_user.nickname).to eq("updated_great_name")
    end
  end

  describe '#destroy' do
    subject do
      delete user_path(user.uid), headers: {
        Authorization: "Bearer #{secret}"
      }
    end

    it 'should return updated status' do
      subject
      expect(response.status).to eq(204)
    end

    it 'should register a user' do
      user
      expect{ subject }.to change(User, :count).by(-1)
    end
  end
end

