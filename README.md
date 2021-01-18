# The OpenWeatherMap-sdk Ruby gem

<p>
  <a href="https://github.com/tiagoleal/OpenWeatherMap-sdk">
    <img alt="Current Version" src="https://img.shields.io/badge/version-1.0.0 -blue.svg">
  </a>
  <a href="https://ruby-doc.org/core-2.7">
    <img alt="Ruby Version" src="https://img.shields.io/badge/Ruby-2.7 -green.svg" target="_blank">
  </a>
</p>

A Ruby interface to the Openweather API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'OpenWeatherMap', git: 'https://github.com/tiagoleal/OpenWeatherMap-sdk.git'

```

And then execute:

    $ bundle install

## Examples files

https://github.com/tiagoleal/OpenWeatherMap-sdk/tree/master/examples

## Usage Examples

After create a `token` OpenweatherMap Api, you can do the following things.

**OpenWeatherMap (show the current forecast)**

```ruby
#id: Your token OpenWeatherMap API (https://openweathermap.org/api)
#city: desired city (optional parameter)
#default city='Santa Cruz do Sul'
client = OpenWeatherMap::Auth.new(id,'Santa Cruz do Sul')
client.current_forecast
```

**OpenWeatherMap (show the next five days forecast)**

```ruby
#id: Your token OpenWeatherMap API (https://openweathermap.org/api)
#city: desired city (optional parameter)
#default city='Santa Cruz do Sul'
client = OpenWeatherMap::Auth.new(id,'Santa Cruz do Sul')
client.next_five_forecast
```

**OpenWeatherMap (show the current and next five days forecast)**

```ruby
#id: Your token OpenWeatherMap API (https://openweathermap.org/api)
#city: desired city (optional parameter)
#default city='Santa Cruz do Sul'
client = OpenWeatherMap::Auth.new(id)
client.complete_forecast
```

## Running tests

OpenweatherMap-sdk uses Rspec as test framework.

- Running all tests:

```bash
rspec spec
```

- Running tests for an specific file:

```bash
rspec spec/OpenWeatherMap_spec.rb
```

## Supported Ruby Versions

This library aims to support and is the following Ruby versions:

- Ruby 2.6
- Ruby 2.7

## Authors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore -->
[<img src="https://avatars1.githubusercontent.com/u/5727529?s=460&v=4" width="100px;"/><br /><sub><b>Tiago Leal</b></sub>](https://github.com/tiagoleal)<br />

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tiagoleal/OpenWeatherMap-sdk.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
