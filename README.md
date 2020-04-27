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
mix run --no-halt # run the application.
```

## Test
To run the tests, run the following command:
```shell
mix test
```

## Comments
As a first improvement the testing procedure should be extended to launch
web-server (for instance cowboy) as a CO2 emission data provider.

Also it will be good to have some metrics here. For example number of successful/unsuccessful requests
and requests duration.

Since the maximum date range is limited to 14 days by data provider as an improvement we should detect
situation when application downtime is more than 14 days and inform somehow or use another API.

It seems that CO2 emission data provider returns nil as actual intensity value for the latest measurement
in case of GET /intensity/{from}/{to} API using, therefore data will be updated during next iteration.
