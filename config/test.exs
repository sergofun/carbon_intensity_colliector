import Config

config :carbon_intensity_collector, :carbon_intensity_api,
       CarbonIntensityCollector.IntensityAPIAdapter.Dummy

config :carbon_intensity_collector, CarbonIntensityCollector.Repo,
       username: "postgres",
       password: "password",
       database: "carbon_intensity_collector_repo_test",
       hostname: "localhost",
       pool: Ecto.Adapters.SQL.Sandbox