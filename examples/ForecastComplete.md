# Forecast Complete

This example return the forecast current and next five days.

```ruby
  def complete_forecast
      current_weather = current_weather_forecast()
      next_five_forecast_days = next_weather_forecast()
      print_temperature(current_weather, next_five_forecast_days)
  end

#id: Your token OpenWeatherMap API (https://openweathermap.org/api)
#city: desired city (optional parameter)
client = OpenWeatherMap::Auth.new(id, city)
client.complete_forecast()
```
