# Forecast Current

This example return the forecast current.

```ruby
    def current_forecast
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

#id: Your token OpenWeatherMap API (https://openweathermap.org/api)
#city: desired city (optional parameter)
client = OpenWeatherMap::Auth.new(id, city)
client.current_forecast()

```
