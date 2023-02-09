# frozen_string_literal: true

module Api
  module V1
    class PingController < ApplicationController
      def index
        render plain: 'pong'
      end
    end
  end
end
