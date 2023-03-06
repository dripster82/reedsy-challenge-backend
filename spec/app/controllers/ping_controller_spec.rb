# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::PingController', type: :request do
  describe '#index' do
    it 'returns pong as the body' do
      get '/api/v1/ping'

      expect(response.body).to eq 'pong'
      expect(response).to have_http_status(:success)
    end
  end
end
