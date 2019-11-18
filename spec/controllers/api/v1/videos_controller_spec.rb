require 'rails_helper'

RSpec.describe 'Api::V1::VideosController', type: :request do

  json = { 'CONTENT_TYPE' => 'application/json' }
  form_data = { 'CONTENT_TYPE' => 'multipart/form-data' }
  video_path = 'spec/fixtures/files/video.mp4'
  img_path = 'spec/fixtures/files/video.jpg'

  let!(:user) { User.create }
  let(:file) { fixture_file_upload(video_path) }
  let(:img) { fixture_file_upload(img_path) }


  describe 'GET /show' do
    context 'new user' do
      it 'should redirect to /signin and return new auth key' do
        get '/api/v1/videos'
        follow_redirect!

        make_default_signin_tests(response, user)
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
      it 'should redirect to /signin and return new auth key' do
        params = { name: 'test_file', source: file }
        post '/api/v1/upload', headers: form_data, params: params
        follow_redirect!

        make_default_signin_tests(response, user)
      end
    end

    context 'user with wrong authentication token' do
      it 'should redirect to /signin and return new auth key' do
        params = { authentication_token: 'wrong token', name: 'test_file', source: file }
        post '/api/v1/upload', headers: form_data, params: params
        follow_redirect!

        make_default_signin_tests(response, user)
      end
    end

    context 'authorized user' do
      context 'upload video' do
        it 'should return :accepted status with file processing status' do
          params = { authentication_token: user.authentication_token, name: 'test_file', source: file }
          post '/api/v1/upload', headers: form_data, params: params
          body = JSON.parse(response.body)

          expect(response).to have_http_status(:ok)
          expect(body).to include('name')
          expect(body['name']).to eq params[:name]
        end
      end

      context 'upload wrong file' do
        it 'should return :not_acceptable status with error json' do
          params = { authentication_token: user.authentication_token, name: 'test_file', source: img }
          post '/api/v1/upload', headers: form_data, params: params
          body = JSON.parse(response.body)

          expect(response).to have_http_status(:not_acceptable)
          expect(body).to include('error')
        end
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
