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
      next_weather_forecast = request_next_weather_forecast
      return send_weather_forecast(current_weather, next_weather_forecast)
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

    def request_next_weather_forecast
      forecast_weather = "http://api.openweathermap.org/data/2.5/forecast?q=Santa%20Cruz%20do%20Sul&lang=pt_br&units=metric&appid=#{@api_key}"
      parse_forecast_weather = request_openweather(forecast_weather)

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
      weather_forecast.group_by { |h| h[:date] }.transform_values { |hs| hs.map { |h| h[:graus].to_i } }
    end

    def send_weather_forecast(current_weather, next_weather_forecast)
      message = "#{current_weather[:temp]}°C e #{current_weather[:description]} em #{current_weather[:city]} "
      message += "em #{current_weather[:date]}. Média para os próximos dias: "

      next_weather_forecast.each do |day, temp|
        next if current_weather[:date].to_s == day.to_s
        average = temp.reduce(:+) / temp.count
        message += "#{average}°C em #{day}, "
      end
      { message: message }
    end

    def request_openweather(url)
      response = RestClient.get url.to_s
      JSON.parse(response.body)
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end
end
