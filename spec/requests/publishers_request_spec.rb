require 'rails_helper'

RSpec.describe "Publishers", type: :request do
  let(:secret) { 'secret_key' }

  before do
    Token.create(label: "awesome_system", key: secret)
  end

  describe '#index' do
    it 'should return proper status' do
      create(:publisher)
      get publishers_path, headers: { Authorization: "Bearer #{secret}" }
      expect(response.status).to eq(200)
    end
  end

  describe '#show' do
    it 'should return proper status' do
      publisher = create(:publisher)
      get publisher_path(publisher.id), headers: { Authorization: "Bearer #{secret}" }
      expect(response.status).to eq(200)
    end
  end

  describe '#create' do
    context 'when correct parameter' do
      let(:valid_params) do
        {
          data: {
            attributes: {
              publisher: "awesome_publisher",
            }
          }
        }
      end

      subject do
        post publishers_path, params: valid_params, headers: { Authorization: "Bearer #{secret}" }
      end

      it 'should return proper status' do
        subject
        expect(response.status).to eq(201)
      end

      it 'should register a publisher' do
        expect{ subject }.to change(Publisher, :count).by(1)
      end
    end

    context 'when incorrect params' do
      let(:invalid_params) do
        {
          data: {
            attributes: {
              publisher: nil,
            }
          }
        }
      end

      subject do
        post publishers_path, params: invalid_params, headers: { Authorization: "Bearer #{secret}" }
      end

      it 'should return proper status' do
        subject
        expect(response.status).to eq(400)
      end

      it 'should not register a publisher' do
        expect{ subject }.to change(Publisher, :count).by(0)
      end
    end
  end
  describe '#update' do
    let(:publisher) { create(:publisher) }
    context 'when correct parameter' do
      let(:valid_params) do
        {
          data: {
            attributes: {
              publisher: "update_awesome_publisher",
            }
          }
        }
      end

      subject do
        patch publisher_path(publisher.id), params: valid_params, headers: { Authorization: "Bearer #{secret}" }
      end

      it 'should return proper status' do
        subject
        expect(response.status).to eq(204)
      end

      it 'should update a publisher' do
        subject
        expect(Publisher.find(publisher.id).publisher).to eq("update_awesome_publisher")
      end
    end

    context 'when incorrect params' do
      let(:invalid_params) do
        {
          data: {
            attributes: {
              publisher: nil,
            }
          }
        }
      end

      subject do
        patch publisher_path(publisher.id), params: invalid_params, headers: { Authorization: "Bearer #{secret}" }
      end

      it 'should return proper status' do
        subject
        expect(response.status).to eq(400)
      end

      it 'should not update a publisher' do
        subject
        expect(Publisher.find(publisher.id).publisher).to eq("出版社")
      end
    end
  end

  describe '#destroy' do
    let(:publisher) { create(:publisher) }
    subject do
      delete publisher_path(publisher.id), headers: { Authorization: "Bearer #{secret}" }
    end

    it 'should return 204 status' do
      subject
      expect(response.status).to eq(204)
    end

    it 'should delete a publisher' do
      publisher
      expect{ subject }.to change(Publisher, :count).by(-1)
    end
  end
end
