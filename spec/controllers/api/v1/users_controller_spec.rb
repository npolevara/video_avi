require 'rails_helper'

RSpec.describe 'Api::V1::UsersController', type: :request do
  describe 'POST Signin' do
    json = { 'CONTENT_TYPE' => 'application/json' }
    let!(:user) { User.create(name:'Max', key: '12345678') }

    context 'new user' do
      it 'should return new auth key' do
        params = { 'name' => 'David', key: '00000' }.to_json

        post '/api/v1/signin', headers: json, params: params
        body = JSON.parse(response.body)
        expect(response.status).to eq 201 # created
        expect(body.has_key?('name')).to eq true
        expect(body['name']).to eq 'David'
        expect(body['key']).to eq '00000'
      end
    end

    context 'signed user' do
      it 'should return user auth key' do
        params = { 'name' => user.name, key: user.key }.to_json

        post '/api/v1/signin', headers: json, params: params
        body = JSON.parse(response.body)
        expect(response.status).to eq 202 # accepted
        expect(body.has_key?('name')).to eq true
        expect(body['name']).to eq user.name
        expect(body['key']).to eq user.key
      end
    end
  end
end
