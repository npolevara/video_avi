module Api
  module V1
    class UsersController < ApplicationController

      def signin
        render json: signed_user.user_json, status: :accepted
      end

      private

      def check_signed_user
        render json: User.create!.user_json, status: :created unless signed_user
      end
    end
  end
end
