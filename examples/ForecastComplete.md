# Forecast Complete

This example return the current and next five days forecast.

```ruby
    def complete_forecast
      [
        current_forecast,
        next_five_forecast
      ]
    end

#id: Your token OpenWeatherMap API (https://openweathermap.org/api)
#city: desired city (optional parameter)
client = OpenWeatherMap::Auth.new(id, city)
client.complete_forecast()

```
