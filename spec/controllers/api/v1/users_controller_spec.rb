require 'rails_helper'

RSpec.describe 'Api::V1::UsersController', type: :request do
  describe 'POST Signin' do
    json = { 'CONTENT_TYPE' => 'application/json' }
    let!(:user) { User.create }

    context 'new user' do
      it 'should return new auth key' do
        # params = { 'name' => 'David', key: '00000' }.to_json

        post '/api/v1/signin', headers: json
        body = JSON.parse(response.body)
        expect(response).to have_http_status(:created)
        expect(body['authentication_token']).to eq User.last.authentication_token
        expect(body['authentication_token']).to_not eq user.authentication_token
      end
    end

    context 'signed user' do
      it 'should return user auth key' do
        params = { key: user.authentication_token }.to_json

        post '/api/v1/signin', headers: json, params: params
        body = JSON.parse(response.body)
        expect(response).to have_http_status(:accepted)
        expect(body['authentication_token']).to eq user.authentication_token
      end
    end
  end
end
