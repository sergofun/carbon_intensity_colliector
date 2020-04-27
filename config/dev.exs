import Config

config :carbon_intensity_collector,
       ecto_repos: [CarbonIntensityCollector.Repo]

config :carbon_intensity_collector, :carbon_intensity_api,
       CarbonIntensityCollector.IntensityAPIAdapter.External

config :carbon_intensity_collector, CarbonIntensityCollector.Repo,
       database: "carbon_intensity_collector_repo",
       username: "postgres",
       password: "password",
       hostname: "localhost"