require 'rails_helper'

RSpec.describe 'Api::V1::UsersController', type: :request do
  describe 'POST Signin' do
    json = { 'CONTENT_TYPE' => 'application/json' }
    let!(:user) { User.create }

    context 'new user' do
      it 'should return new auth key if no params' do
        get '/api/v1/signin', headers: json
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(body['authentication_token']).to eq User.last.authentication_token
        expect(body['authentication_token']).to_not eq user.authentication_token
      end

      it 'should return new auth key wrong params' do
        request = '/api/v1/signin?name=devid&key=00000'
        get request, headers: json
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(body).to include('authentication_token', '_id')
        expect(body['authentication_token']).to eq User.last.authentication_token
        expect(body['authentication_token']).to_not eq user.authentication_token
        expect(body['_id']['$oid']).to eq User.last._id.to_s
      end
    end

    context 'signed user' do
      it 'should return user auth key' do
        request = "/api/v1/signin?_id=#{user.id}&authentication_token=#{user.authentication_token}"
        get request, headers: json
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:accepted)
        expect(body).to include('authentication_token', '_id')
        expect(body['authentication_token']).to eq user.authentication_token
        expect(body['_id']['$oid']).to eq user._id.to_s
      end
    end
  end
end
