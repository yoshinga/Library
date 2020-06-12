require 'rails_helper'

RSpec.describe "Users", type: :request do
  let (:valid_params) do
    {
      users: {
        role: '1',
        nickname: 'super_great_name',
        user_id: '1',
      }
    }
  end

  before do
    Token.create(label: "awesome_system", key: "secret_key")
  end

  describe '#create' do
    subject do
      post users_path, params: valid_params, headers: { Authorization: 'Bearer secret_key' }
    end

    it 'should return created status' do
      subject
      expect(response.status).to eq(201)
    end

    it 'should register a user' do
      post users_path, params: valid_params, headers: { Authorization: 'Bearer secret_key' }
      expect { subject }.to change(User, :count).by(1)
    end
  end
end

