# CarbonIntensityCollector

Carbon Intensity collector application performs CO2 emission values acquisition in accordance
with configured source and stores carbon emission values in teh PostgreSQL database.

## Installation

Since Carbon Intensity Collector uses PostgreSQL as a data storage you have to install it first:
* [PostgreSQL](https://www.postgresql.org/download/)

You can specify desired data requst period in config/config.exs(default value 30min):
```elixir
config :carbon_intensity_collector, CarbonIntensityCollector.Scheduler,
       debug_logging: false,
       global: false,
       jobs: [
         {"*/30 * * * *",  {CarbonIntensityCollector.Gatherer, :perform_data_acquisition, []}},
       ]
```

Configure connect to the database in config/config.exs and config/test.exs
```elixir
config :carbon_intensity_collector, CarbonIntensityCollector.Repo,
  database: "carbon_intensity_collector_repo",
  username: "postgres",
  password: "password",
  hostname: "localhost"
```

To get started, run the following commands in the project folder:
```shell
mix deps.get  # installs the dependencies
mix ecto.create  # creates the database.
mix ecto.migrate  # run the database migrations.
mix run  # run the application.
```

## Test
To run the tests, run the following command:
```shell
mix test
```
