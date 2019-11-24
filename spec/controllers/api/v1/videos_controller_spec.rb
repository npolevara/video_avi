require 'rails_helper'

RSpec.describe 'Api::V1::VideosController', type: :request do

  json = { 'CONTENT_TYPE' => 'application/json' }
  form_data = { 'CONTENT_TYPE' => 'multipart/form-data' }
  video_path = 'spec/fixtures/files/video.mp3'
  img_path = 'spec/fixtures/files/video.jpg'

  def download_link(video_file)
    link = "#{ENV['ROOT_URL']}/api/v1/download?authentication_token=#{video_file.user.authentication_token}"
    link += "&name=#{video_file.name}&id=#{video_file._id.to_str}"
    link
  end

  let!(:user) { User.create }
  let(:file) { fixture_file_upload(video_path) }
  let(:img) { fixture_file_upload(img_path) }
  let(:video) do
    Video.create!(name: 'some_name',
                  user_id: user._id,
                  source: file,
                  cut_from: 5,
                  cut_length: 20,
                  status: 'done',
                  length: '10:00')
  end

  let(:failed_video) do
    Video.create!(name: 'fail_name',
                  user_id: user._id,
                  source: file,
                  cut_from: 5,
                  cut_length: 20,
                  status: 'fails: errors')
  end

  describe 'GET /show' do
    context 'new user' do
      it 'should redirect to /signin and return new auth key' do
        get '/api/v1/videos'
        follow_redirect!

        make_default_signin_tests(response, user)
      end
    end

    context 'authorized user' do
      before { video }
      it 'should return user videos list json' do
        request = "/api/v1/videos?_id=#{user.id}&authentication_token=#{user.authentication_token}"
        get request, headers: json
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:accepted)
        expect(body).to include('video_list', 'id')
        expect(body['id']).to eq user._id.to_str
        expect(body['video_list'].first).to contain_exactly(video.name, video.status, video.length, video.file_path)
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
          params = { authentication_token: user.authentication_token,
                     name: 'test_file',
                     source: file,
                     cut_from: 10,
                     cut_length: 25
          }
          expect { post '/api/v1/upload', headers: form_data, params: params }
              .to change { user.videos.count }.by(1)
          expect(user.videos.count).to eq(1)
          perform_enqueued_jobs

          body = JSON.parse(response.body)
          expect(response).to have_http_status(:ok)
          expect(body).to include('name')
          expect(body['name']).to eq params[:name]
          expect(user.videos.count).to eq(2)

          original_video = user.videos.first
          cropped_video = user.videos.last
          expect(original_video.name).to_not match(/.+\_cropped$/)
          expect(cropped_video.name).to match(/.+\_cropped$/)

          expect(original_video.file_path).to eq download_link(original_video)
          expect(cropped_video.file_path).to eq download_link(cropped_video)

          original_file = File.open(original_video.source.file.file, 'r').size
          cropped_file = File.open(cropped_video.source.file.file, 'r').size
          expect(cropped_file).to be < original_file
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

  describe 'POST /restart' do
    context 'new user' do
      it 'should redirect user to /show as a new user' do
        params = { authentication_token: 'wrong token', name: 'test_file', cut_from: 10, cut_length: 25 }.to_json
        post '/api/v1/restart', headers: json, params: params
        follow_redirect!

        make_default_signin_tests(response, user)
      end
    end

    context 'authorized user' do
      before { video }
      it 'should return :accepted status with file processing status' do
        params = { authentication_token: user.authentication_token, name: failed_video.name, cut_from: 10, cut_length: 25 }
        post '/api/v1/restart', headers: form_data, params: params
        perform_enqueued_jobs

        body = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(body).to include('name', 'status')
        expect(body['name']).to eq failed_video.name
        expect(body['status']).to eq 'scheduled'
        expect(video.status).to eq 'done'
      end
    end
  end
end
