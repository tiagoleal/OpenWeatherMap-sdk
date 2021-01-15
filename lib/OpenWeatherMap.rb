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
  # Your code goes here...

  class Auth
    attr_accessor :api_key

    def initialize(id)
      @api_key = id
    end

    def get_openweather_temperature
      Time.zone = 'America/Sao_Paulo'
      current_weather = request_current_weather
      current_weather
    end

    private

    def request_current_weather
      current_weather = "http://api.openweathermap.org/data/2.5/weather?q=Santa%20Cruz%20do%20Sul&lang=pt_br&units=metric&appid=#{@api_key}"
      parse_current_weather = request_openweather(current_weather)
      {
        date: Time.zone.at(parse_current_weather['dt']).strftime('%d/%m'),
        temp: parse_current_weather['main']['temp'].to_i,
        description: parse_current_weather['weather'][0]['description'],
        city: parse_current_weather['name']
      }
    end

    def request_openweather(url)
      response = RestClient.get url.to_s
      JSON.parse(response.body)
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end
end
