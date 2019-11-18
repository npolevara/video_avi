require 'rails_helper'

RSpec.describe 'Api::V1::VideosController', type: :request do

  json = { 'CONTENT_TYPE' => 'application/json' }

  describe 'GET /show' do
    let!(:user) { User.create }
    context 'new user' do
      it 'should return new auth key' do
        get '/api/v1/videos'
        body = JSON.parse(response.body)
        expect(response).to have_http_status(:created)
        expect(body).to include('video_list', '_id')
        expect(body['_id']['$oid']).to eq User.last._id.to_s
        expect(body['video_list']).to be_empty
      end
    end

    context 'authorized user' do
      it 'should return user show json' do
        request = "/api/v1/videos?_id=#{user.id}&authentication_token=#{user.authentication_token}"
        get request, headers: json
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:accepted)
        expect(body).to include('video_list', '_id')
        expect(body['_id']['$oid']).to eq user._id.to_s
      end
    end
  end

  describe 'POST /upload' do
    context 'new user' do
      it 'should redirect user to /show as a new user' do

      end
    end

    context 'authorized user' do
      it 'should return :accepted status with file processing status' do
        #post '/api/v1/upload'
      end
    end
  end
  #
  #describe 'POST /restart' do
  #  context 'new user' do
  #    it 'should redirect user to /show as a new user' do
  #
  #    end
  #  end
  #
  #  context 'authorized user' do
  #    it 'should return :accepted status with file processing status' do
  #
  #    end
  #  end
  #end

end
