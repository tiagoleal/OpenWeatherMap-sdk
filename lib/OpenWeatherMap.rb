# frozen_string_literal: true

require 'OpenWeatherMap/version'

# Dependencia da gem que faz a chamada REST
require 'rest-client'
# Dependencia para parsear o JSON
require 'json'

require 'active_support'
require 'active_support/time'

module OpenWeatherMap
  class Error < StandardError; end

  class Auth
    attr_accessor :api_key, :city

    def initialize(id, city = 'Santa Cruz do Sul')
      @api_key = id
      @city = city
    end

    def current_forecast
      Time.zone = 'America/Sao_Paulo'
      parse_current_weather = request_openweather('weather')
      {
        current_weather: {
          date: Time.zone.at(parse_current_weather['dt']).strftime('%d/%m'),
          temp: parse_current_weather['main']['temp'].to_i,
          description: parse_current_weather['weather'][0]['description'],
          city: parse_current_weather['name']
        }
      }
    end

    def next_five_forecast
      Time.zone = 'America/Sao_Paulo'
      parse_forecast_weather = request_openweather('forecast')
      timestamp_now = Time.now.to_i
      weather_forecast = parse_forecast_weather['list'].map do |temp|
        next unless timestamp_now <= temp['dt']

        info_temperature = {
          timestamp: temp['dt'],
          dt: Time.zone.at(temp['dt']).strftime('%d/%m/%Y %H:%M:%I'),
          graus: (temp['main']['temp']).to_s,
          clima: (temp['weather'][0]['description']).to_s,
          date: Time.zone.at(temp['dt']).strftime('%d/%m')
        }
      end
      weather_forecast.delete_if { |date| date[:date] == weather_forecast[0][:date] }
      { next_five_weather: weather_forecast.group_by { |h| h[:date] }.transform_values { |hs| hs.map { |h| h[:graus].to_i } } }
    end

    def complete_forecast
      [
        current_forecast,
        next_five_forecast
      ]
    end

    private

    def request_openweather(url)
      openweather_url = "http://api.openweathermap.org/data/2.5/#{url}?q=#{@city}&lang=pt_br&units=metric&appid=#{@api_key}"
      response = RestClient.get openweather_url.to_s
      JSON.parse(response.body)
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end
end
