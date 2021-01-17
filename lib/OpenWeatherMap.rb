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
      current_weather = current_weather_forecast
      message = "Previsão: #{current_weather[:temp]}°C e #{current_weather[:description]} em #{current_weather[:city]} "
      message += "em #{current_weather[:date]}."
      { message: message }
    end

    def next_five_forecast
      next_five_forecast_days = next_weather_forecast
      message = "Média para os próximos dias em (#{@city}): "

      next_five_forecast_days.each do |day, temp|
        average = temp.reduce(:+) / temp.count
        message += "#{average}°C em #{day},"
      end
      format_massage = message.gsub(/[\&,]/, '.')
      { message: format_massage }
    end

    def complete_forecast
      current_weather = current_weather_forecast
      next_five_forecast_days = next_weather_forecast
      print_temperature(current_weather, next_five_forecast_days)
    end

    private

    def current_weather_forecast
      Time.zone = 'America/Sao_Paulo'
      openweathermap_url = "http://api.openweathermap.org/data/2.5/weather?q=#{@city}&lang=pt_br&units=metric&appid=#{@api_key}"
      parse_current_weather = request_openweather(openweathermap_url)
      {
        date: Time.zone.at(parse_current_weather['dt']).strftime('%d/%m'),
        temp: parse_current_weather['main']['temp'].to_i,
        description: parse_current_weather['weather'][0]['description'],
        city: parse_current_weather['name']
      }
    end

    def next_weather_forecast
      Time.zone = 'America/Sao_Paulo'
      openweathermap_url = "http://api.openweathermap.org/data/2.5/forecast?q=#{@city}&lang=pt_br&units=metric&appid=#{@api_key}"
      parse_forecast_weather = request_openweather(openweathermap_url)

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

    def print_temperature(current_weather, next_weather_forecast)
      message = "#{current_weather[:temp]}°C e #{current_weather[:description]} em #{current_weather[:city]} "
      message += "em #{current_weather[:date]}. Média para os próximos dias: "

      next_weather_forecast.each do |day, temp|
        next if current_weather[:date].to_s == day.to_s

        average = temp.reduce(:+) / temp.count
        message += "#{average}°C em #{day}, "
      end
      format_massage = message.gsub(/[\&,]/, '.')
      { message: format_massage }
    end

    def request_openweather(url)
      response = RestClient.get url.to_s
      JSON.parse(response.body)
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end
end
