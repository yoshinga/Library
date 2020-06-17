require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user) }
  let(:publisher) { create(:publisher) }
  let(:book) { create(:book, owner_id: user.id, publisher_id: publisher.id) }
  let(:secret) { 'secret_key' }

  before do
    Token.create(label: "awesome_system", key: secret)
  end

  describe '#create' do
    context 'when correct parameter' do
      let(:valid_params) do
        {
          data: {
            attributes: {
              user_id: user.id,
              book_id: book.id,
              content: "super great comment",
            }
          }
        }
      end

      subject do
        post comments_path, params: valid_params, headers: { Authorization: "Bearer #{secret}" }
      end

      it 'should return proper status' do
        subject
        expect(response.status).to eq(201)
      end

      it 'should register a comment' do
        expect{ subject }.to change(Comment, :count).by(1)
      end
    end

    context 'when incorrect params' do
      let(:invalid_params) do
        {
          data: {
            attributes: {
              user_id: user.id,
              book_id: book.id,
              content: nil,
            }
          }
        }
      end

      subject do
        post comments_path, params: invalid_params, headers: { Authorization: "Bearer #{secret}" }
      end

      it 'should return proper status' do
        subject
        expect(response.status).to eq(400)
      end

      it 'should not register a comment' do
        expect{ subject }.to change(Comment, :count).by(0)
      end
    end
  end

  describe '#update' do
    let(:comment) { create(:comment) }
    context 'when correct parameter' do
      let(:valid_params) do
        {
          data: {
            attributes: {
              user_id: user.id,
              book_id: book.id,
              content: "updated super great comment",
            }
          }
        }
      end

      subject do
        patch comment_path(comment.id), params: valid_params, headers: { Authorization: "Bearer #{secret}" }
      end

      it 'should return proper status' do
        subject
        expect(response.status).to eq(204)
      end

      it 'should update a comment' do
        subject
        expect(Comment.find(comment.id).content).to eq("updated super great comment")
      end
    end

    context 'when incorrect params' do
      let(:invalid_params) do
        {
          data: {
            attributes: {
              user_id: user.id,
              book_id: book.id,
              content: nil,
            }
          }
        }
      end

      subject do
        patch comment_path(comment.id), params: invalid_params, headers: { Authorization: "Bearer #{secret}" }
      end

      it 'should return proper status' do
        subject
        expect(response.status).to eq(400)
      end

      it 'should not update a comment' do
        subject
        expect(Comment.find(comment.id).content).to eq("It was good book")
      end
    end
  end

  describe '#destroy' do
    let(:comment) { create(:comment) }
    subject do
      delete comment_path(comment.id), headers: { Authorization: "Bearer #{secret}" }
    end

    it 'should return 204 status' do
      subject
      expect(response.status).to eq(204)
    end

    it 'should delete a comment' do
      comment
      expect{ subject }.to change(Comment, :count).by(-1)
    end
  end
end
