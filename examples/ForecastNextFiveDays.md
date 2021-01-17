# Forecast Next Five Days

This example return the forecast next five days.

```ruby
  def next_five_forecast
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

#id: Your token OpenWeatherMap API (https://openweathermap.org/api)
#city: desired city (optional parameter)
client = OpenWeatherMap::Auth.new(id, city)
client.next_five_forecast()
```
