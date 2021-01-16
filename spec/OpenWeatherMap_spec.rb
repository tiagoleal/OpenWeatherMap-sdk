# frozen_string_literal: true

RSpec.describe OpenWeatherMap do
  it 'has a version number' do
    expect(OpenWeatherMap::VERSION).not_to be nil
  end

  describe 'GET /data/2.5/weather?q=Santa%20Cruz%20do%20Sul&lang=pt_br&units=metric&appid=' do
    context 'Request OpenWeather Api' do
      it 'Api response == 200' do
        api_key = 'f32b88630791a7026ad9e5bceddafec5'
        get "http://api.openweathermap.org/data/2.5/weather?q=Santa%20Cruz%20do%20Sul&lang=pt_br&units=metric&appid=#{api_key}"
        expect(response['code']).to eq(200)
      end
    end
  end
end
