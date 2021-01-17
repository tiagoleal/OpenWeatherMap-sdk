# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OpenWeatherMap do
  it 'has a version number SDK' do
    expect(OpenWeatherMap::VERSION).not_to be nil
  end

  describe 'When call openweathermap' do
    context 'OpenweatherMap constructor params' do
      it 'With valid params' do
        openweathermap = OpenWeatherMap::Auth.new(OPENWEATHERMAP_TOKEN)
        expect(openweathermap).present?
      end

      it 'With invalid params' do
        expect { OpenWeatherMap::Auth.new }.to raise_error(ArgumentError)
      end
    end

    context 'OpenweatherMap methods' do
      before do
        @openweathermap = OpenWeatherMap::Auth.new(OPENWEATHERMAP_TOKEN)
      end

      it '#current_forecast' do
        response = @openweathermap.current_forecast
        expect(response.keys).to match_array([:current_weather])
      end

      it '#next_five_forecast' do
        response = @openweathermap.next_five_forecast
        expect(response.keys).to match_array([:next_five_weather])
      end
    end

    context 'Request openweatherMap API' do
      it 'Return a 200 ok response' do
        url = "http://api.openweathermap.org/data/2.5/weather?q=Lajeado&lang=pt_br&units=metric&appid=#{OPENWEATHERMAP_TOKEN}"
        response = RestClient.get url.to_s
        expect(response.code).to eq(200)
      end

      it 'Return a 401 Unauthorized response' do
        url = 'http://api.openweathermap.org/data/2.5/weather?q=Lajeado&lang=pt_br&units=metric&appid=f32b88630791a7026ad9e5bcedda0000'
        expect { RestClient.get url.to_s }.to raise_error(RestClient::Unauthorized, '401 Unauthorized')
      end
    end
  end
end
