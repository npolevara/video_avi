require 'rails_helper'

RSpec.describe 'Api::V1::VideosController', type: :request do

  describe 'GET /show' do
    context 'new user' do
      it 'should return empty show json' do

      end
    end

    context 'authorized user' do
      it 'should return user show json' do

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
        post '/api/v1/'
      end
    end
  end

  describe 'POST /restart' do
    context 'new user' do
      it 'should redirect user to /show as a new user' do

      end
    end

    context 'authorized user' do
      it 'should return :accepted status with file processing status' do

      end
    end
  end

end
