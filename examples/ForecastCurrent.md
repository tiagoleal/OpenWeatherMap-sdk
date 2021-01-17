# Forecast Current

This example return the forecast current.

```ruby
    def current_forecast
      current_weather = current_weather_forecast
      message = "Previsão: #{current_weather[:temp]}°C e #{current_weather[:description]} em #{current_weather[:city]} "
      message += "em #{current_weather[:date]}."
      { message: message }
    end
#id: Your token OpenWeatherMap API (https://openweathermap.org/api)
#city: desired city (optional parameter)
client = OpenWeatherMap::Auth.new(id, city)
client.current_forecast()
```
